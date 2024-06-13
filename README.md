# webMethods Build Docker Image GitHub Action
Github Action for building customized container images on top of webMethods product images, including packages installation

## Usage
:warning: To leverage the full capabilities of the action, please use the conventional build-args when designing your Dockerfile. The bellow inputs specify their corresponding build-arg name, passed to the docker build process.
| Setting        | Default value           | Description  |
| :-------------: | :-------------: | ------------- |
| context      |  | The docker build context |
| dockerfile      |  | The dockerfile to use for the build |
| image-name      |  | The full name of the image to build |
| base-runtime      |  | The base runtime image to use. Passed as baseruntime build-arg to the docker build process |
| builder-number      |  | The build number. Passed as buildnumber build-arg to the docker build process |
| extra-args      |  | The extra arguments (build-args) to pass to the docker build process |
| wpm-registry-server      | https://packages.webmethods.io | The webMethods packages registry server to use for pulling packages. Passed as wpmregistryserver build-arg to the docker build process |
| wpm-registry      | licensed | The webMethods packages registry to use from the webMethods packages registry server. Passed as wpmregistry build-arg to the docker build process |
| wpm-registry-token      |  | The webMethods packages registry authentication token. Passed as wpmregistrytoken build-arg to the docker build process |
| packages      |  | Packages to install, registered in the webMethods packages registry, seperated by space (e.g. "WmPackage1 WmPackage2"). Passed as packages build-arg to the docker build process |
| custom-packages-org-url      |  | The GitHub organization URL for pulling custom packages located in GitHub. Passed as custompackagesorgurl build-arg to the docker build process |
| custom-packages      |  | Custom Packages to install, located in the specified GitHub organization, seperated by space (e.g. "CustomPackage1:main CustomPackage2:v1").  Passed as custompackages build-arg to the docker build process |

## Outputs 
| Output        | Description  |
| :-------------: | ------------- |
| image-name     | The full name of the built image (e.g. mycontainerregistry.com/myimage:mytag ) |
| image-repository     | The repository part of the built image (e.g mycontainerregistry.com/myimage) |
| image-tag     | The tag part of the built image (e.g. mytag) |

## Example

```yml
- name: Build custom image
  id: build-image
  uses: wm-private-cloud/wm-build-image@v2
  with:
    context: "."
    dockerfile: MSR/Dockerfile
    image-name: mycontainerregistry.com/myimage:mytag
    wpm-registry-token: ${{ secrets.WM_WPM_TOKEN }}
    packages: "WmPackage1 WmPackage2"
    custom-packages: "CustomPackage1:main CustomPackage2:v1"
    custom-packages-org-url: "https://github.com/myorganization"
```
