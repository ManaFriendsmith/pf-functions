output_directory_name="pf-functions_1.0.0"

mkdir "../$output_directory_name"
cp -r * "../$output_directory_name"
rm "../$output_directory_name/publish.sh"
cd ..
zip -rm "$output_directory_name.zip" "$output_directory_name"