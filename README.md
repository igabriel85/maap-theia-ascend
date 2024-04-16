# Docker container for MAAP Eclipse Che workspace

This repository contains the Dockerfile and associated files for building a Docker container for the MAAP Eclipse Che workspace.
It is based on the Universal developer image UBI8 provided by Red Hat.
Workspace is running on Python 3.10.13 and conda environment.


# Building the Docker container
This workspace and associated Docker container are part of this repository. The `maap-theia-dev` folder contains the files
and Dockerfile needed to build the Docker container. The Docker container is built using the following command:
```bash
docker build --no-cache -t maap-theia-dev
```

Once the image is built it can be uploaded to a Docker registry. The image can be uploaded to a Docker registry. An example can be found here:
```bash
docker tag maap-theia-dev quay.io/maap/maap-theia-dev
```

```bash
docker push quay.io/maap/maap-theia-dev
```

The resulting image can be used in the devfile.yaml file for the Eclipse Che workspace. See section [Devfile](#Devfile) for more information.

We should note that a Conda environment named `pymaap` will be created and activated once the container is started. This environment is based on Python 3.10.13 and contains the following packages:

  - folium=0.15.1
  - gitpython=3.1.40
  - ipyleaflet=0.18.1
  - jupyterlab=3.6.3
  - jupyterlab-git=0.34.2
  - jupyter-packaging=0.12.3
  - jupyterlab_widgets=3.0.7
  - nodejs=18.15.0
  - plotly=5.18.0
  - plotnine=0.12.2
  - plotnine=0.12.2
  - awscli=2.14.1
  - backoff=2.2.1
  - basemap=1.3.7
  - boto3=1.34.15
  - cython=3.0.7
  - earthengine-api=0.1.384
  - gdal=3.7.0
  - geocube=0.4.2
  - geopandas=0.14.2
  - h5py=3.9.0
  - hdf5=1.14.0
  - httpx=0.26.0
  - mapclassify=2.6.1
  - matplotlib=3.7.3
  - mizani=0.10.0
  - mpl-scatter-density=0.7
  - numba=0.58.1
  - numpy=1.26.3
  - pandas=2.1.4
  - pandarallel=1.6.5
  - pycurl=7.45.1
  - pygeos=0.14
  - pyogrio=0.6.0
  - pyproj=3.5.0
  - pystac-client=0.7.5
  - python=3.10.13
  - rasterio=1.3.7
  - rasterstats=0.19.0
  - requests=2.31.0
  - rio-cogeo=5.1.1
  - rtree=1.1.0
  - s3fs=0.4.2
  - scikit-learn=1.3.2
  - scipy=1.11.4
  - seaborn=0.13.1
  - shapely=2.0.1
  - sliderule=4.1.0
  - statsmodels=0.14.1
  - tqdm=4.66.1
  - unidecode=1.3.7
  - xmltodict=0.13.0
  - pip=23.3.2
  - jupyter-resource-usage==0.7.2
  - rio-tiler==6.2.8
  - morecantile==5.1.0

## List of files in Container

- `Dockerfile`: The Dockerfile for building the Docker container.
- `README.md`: This file.
- `LICENSE`: The license file for this repository.
- `entrypoint.sh`: The entrypoint script for the Docker container.
- `environment.yml`: The environment file for the conda environment.
- `initTemplates.sh`: ?? (decompresez an arhive with templates for Eclipse non Che)
- `sharedAlgorythms.sh`: Script for cloning git repository, guides user through git configuration.
- `ingestData.sh`: Script for fetching data based on configuration from project template.
- `ingestData.py`: Python script for fetching data based on configuration from project template.
- `maap-s3.py`: Python script for fetching data from MAAP S3 bucket.
- `RestClient.py`: ??.
- `installLib.sh`: fetches requirements.txt file from url and installs the packages. Packages are:
    - property
    - requests
    - namedlist==1.7
    - scikit-image
    - equi7grid==0.0.10
    - numpydoc==0.8.0
    - packaging==19.0
    - pyproj
    - pytileproj
    - scipy
    - matplotlib
    - pillow
    - pandas
    - Shapely
    - octave_kernel
    - fiona
    - scikit-learn
- 
# IDEs
 In order to customize IDE edit the .che/che-editor.yaml file.
Current options are supported:
 - Eclipse Theia (VSCODE) (default)
```yaml
id: che-incubator/che-code/latest
```
- PyCharm (not working)
```yaml
id: che-incubator/che-pycharm/latest
```
- IntelliJ IDEA (not working)
```yaml
id: che-incubator/che-intellij/latest
```

# Devfile

The devfile is a configuration file that defines the workspace. It is used by Eclipse Che to create the workspace. The devfile for the MAAP Eclipse Che workspace is located in this repository. 
The devfile is named `devfile.yaml`. 

Users can define the workspace by editing the devfile. The devfile contains the following sections:
- `metadata`: Contains metadata about the workspace.
- `attributes`: Contains attributes for the workspace.
- `components`: Contains information about the components in the workspace.
- `commands`: Contains information about the commands in the workspace.
- `plugins`: Contains information about the plugins in the workspace.

The `attributes` section can be used to define what plugins are installed in the workspace. The `plugins` section can be used to define what plugins are installed in the workspace. The `components` section can be used to define what components are installed in the workspace.
Currently we have the following plugins:
```yaml
attributes:
   .vscode/extensions.json: |
      {
         "recommendations": [
            "redhat.java",
            "ms-python.python",
            "ms-toolsai.jupyter",
            "ms-azuretools.vscode-docker",
            "redhat.vscode-yaml",
            "ms-azuretools.vscode-docker"
         ]
      }
   .che/che-theia-plugins.yaml: |
       - id: redhat/vscode-yaml
       - id: ms-python/python
       - id: ms-toolsai/jupyter
```

Alternatively, the `extensions.json` and `che-theia-plugins.yaml` files can be used to define in the `.vscode` and `.che` folders respectively. Both methods are used for demonstration in this repository.

In the `components` section we define the container to be used, the one defined in the [Container](#Building the Docker container) sections of this readme.
Here users can also define parameters such as CPU and memory limits for the workspace. 

The `commands` section can be used to define what commands are available in the workspace. 

# Adding workspace to Eclipse Che

## Manual
Eclipse Che only requires a valid devfile to create a workspace. The devfile for the MAAP Eclipse Che workspace is located in this repository. Thus, we can just specify
the URL of this repository in  Eclipse Che workspace creation textbox.

## Kubernetes ConfigMap
Alternatively, if we have administrator access to Eclipse Che, we can add the workspace to the list of available workspaces in the `getting-started-sample` Kubernetes configmap. We can use `kubectl` as follows:

```bash
kubectl create configmap getting-started-samples --from-file=maap_sample.json -n eclipse-che
```

```bash
kubectl label configmap getting-started-samples app.kubernetes.io/part-of=che.eclipse.org app.kubernetes.io/component=getting-started-samples -n eclipse-che
```

Please note that some of the commands above may require administrator access to the Kubernetes cluster and the Eclipse Che namespace.

An example of the `maap_sample.json` file is provided in this repository. The file contains the following information:
```json
[
  {
    "displayName": "MAAP Python 3.10.13",
    "description": "Python 3.10.13 sample MAAP using vanilla environment",
    "tags": "maap, python 3.10.13",
    "url": "https://github.com/igabriel85/maap-theia",
    "icon": {
      "base64data": "<base64_encoded_data>",
      "mediatype": "image/png"
    }
  },
  {
    "displayName": "MAAP Jupyter Python 3.10.13",
    "description": "Python 3.10.13 sample MAAP using Jupyter environment",
    "tags": "maap, python 3.10.13",
    "url": "https://github.com/igabriel85/maap-jupyter",
    "icon": {
      "base64data": "<base64_encoded_data>",
      "mediatype": "image/png"
    }
  }
]
```
For custom icons, we must convert the image data into base64 encoding. We can use online tools such as [base64-image.de](https://www.base64-image.de/) to convert the image data to base64 encoding.

## Devfile Registry

We can also create a custom devfile registry. This registry contains the devfile for the MAAP Eclipse Che workspace. It will enable complete controll over what sample workspaces are available in Eclipse Che. The other methods will just add the workspace to the list of available workspaces in Eclipse Che.
For a complete overview of how we can use the Devfile Registry, please refer to the [MAAP Eclipse Che devfile registry](https://gitlab.dev.info.uvt.ro/sage/maap/che-dev-file-registry).


# ToDos