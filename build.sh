
#!/usr/bin/env bash
version=$1
if [[ -z "$version" ]]; then
  echo "usage: $0 <version-tag>"
  exit 1
fi

package_name="terraform-provider-ospath"
platforms=(
    "windows/386"
    "windows/amd64"
    "darwin/386"
    "darwin/amd64"
    "linux/386"
    "linux/amd64"
)

for platform in "${platforms[@]}"
do
    echo "Building $platform"
    platform_split=(${platform//\// })
    GOOS=${platform_split[0]}
    GOARCH=${platform_split[1]}
    output_name="./build/$GOOS-$GOARCH/${package_name}_$version"
    if [ $GOOS = "windows" ]; then
        output_name+='.exe'
    fi  

    env GOOS=$GOOS GOARCH=$GOARCH go build -o $output_name main.go
    if [ $? -ne 0 ]; then
        echo 'An error has occurred! Aborting the script execution...'
        exit 1
    fi
done
