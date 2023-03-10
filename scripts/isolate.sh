#! /bin/sh

script="$1"
after="$CI_EMULATE_AFTER"

set -eu

onExit() {
	rc="$?"
	if [ "$rc" = '0' ]; then
		echo "โ CI Emulation completed without problems!"
	else
		echo "โ Failed start CI emulation!"
	fi
}
trap onExit EXIT

echo "๐ฟ Creating docker volumes..."
docker volume create nix-vol
docker volume create docker-vol
echo "โ Volumes created!"

echo "๐ณ Initializing Nix DinD container..."
container_id=$(docker run --privileged -id -v nix-vol:/nix -v docker-vol:/var/lib/docker -e NIXPKGS_ALLOW_UNFREE=1 -w=/workspace ghcr.io/kirinnee/nix-dind/nix-dind:main-01c761)
echo "โ Nix DinD container initialized!"

cleanUp() {
	rc="$?"
	echo "๐งน Clean up containers removing containers..."
	docker kill "${container_id}"
	docker rm "${container_id}"
	echo "โ Containers removed!"
	if [ "$rc" = '0' ]; then
		echo "โ CI Emulation completed without problems!"
	else
		echo "โ Failed run CI emulation!"
	fi
}
trap cleanUp EXIT

echo "๐ Copying files into container..."
docker cp -a . "$container_id:/data"
docker exec "${container_id}" chown -R root /data
echo "โ Files copied into container!"

echo "๐ณ Commit all files within container..."
docker exec "${container_id}" /data/scripts/emulate-commit.sh >/dev/null
echo "โ Files committed!"

echo "๐๏ธ Emulate git clone..."
docker exec "${container_id}" git clone /data /workspace >/dev/null
echo "โ Git clone emulated!"

if [ "${script}" = '' ]; then
	echo "๐ช Entering container..."
	(docker exec -ti "${container_id}" sh) || true
elif [ "${script}" = ':nix-shell:' ]; then
	echo "๐ช Entering container..."
	(docker exec -ti "${container_id}" nix-shell /workspace/nix/shells.nix -A ci) || true
else
	echo "๐โ Running script '${script}'..."
	docker exec -t "${container_id}" "scripts/ci/${script}.sh"
	if [ "${after}" = 'enter' ]; then
		(docker exec -ti "${container_id}" sh) || true
	fi
fi
