# CCI Benchmark 

Sections with :rocket: symbol have been configured and do not need to be executed. 

The benchmark environment will be managed using Conda.

### Install Conda :rocket:

```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

bash *.sh
# exit and re-entry shell

conda install -n base -c conda-forge mamba

conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
```

## 1. Config the CCI evaluation repo

See [CCI](https://github.com/wanglabtongji/CCI) for details about the workflow

### 1.1 R in Conda :rocket:

```
name: RENV
channels:
 - conda-forge
dependencies:
 - python=3.9
 - r-base=4.2
 - r-tidyverse
 - stlearn
 - pkg-config
```

```
mamba env create --file renv.yml
```

The R environment can be activated

```
conda activate RENV
```



#### 1.1.1 devtools :rocket:

```
sudo apt -y install build-essential \
libcurl4-gnutls-dev libxml2-dev \
libssl-dev libfontconfig1-dev \
libharfbuzz-dev libfribidi-dev \
libfreetype6-dev libpng-dev \
libtiff5-dev libjpeg-dev \
cmake

# mamba install -c conda-forge pkg-config
```

```R
R -e 'install.packages(c("BiocManager","devtools"),repos = "http://cran.us.r-project.org")'
```

```
sudo apt-get install gfortran liblapack-dev libblas-dev liblapack3 libopenblas-base
```



#### 1.1.2  Install CCI R Tools:rocket:

CellChat

```r
R -e 'install.packages(c("optparse"),repos = "http://cran.us.r-project.org")'
R -e 'BiocManager::install("Biobase")'
R -e 'BiocManager::install("ComplexHeatmap")'
R -e 'BiocManager::install("BiocNeighbors")'
R -e 'install.packages(c("pheatmap"),repos = "http://cran.us.r-project.org")'
R -e 'devtools::install_github("sqjin/CellChat")'
```

[Gitto](https://giottosuite.readthedocs.io/en/latest/gettingstarted.html)

```R
# sudo apt update && sudo apt -y install libmagick++-dev
#sudo apt -y install libgdal-dev gdal-bin libproj-dev
# mamba install -c conda-forge r-rgdal
# I wasn't able to install magick in R, so using mamba
mamba install -c conda-forge r-magick
R -e  'devtools::install_github("drieslab/Giotto")'
```

### 1.2 Install CCI python Tools

#### 1.2.1 CellPhoneDB V3 :rocket:



```
# # Feb-07-2023
# Current version in pip is 3.1.0,
# cbdb v4 is on the way.
# mamba env create --file cpdb_latest.yml
name: cpdb_latest
dependencies:
  - python=3.8
  - pip
  - r-base
  - r-ggplot2
  - r-pheatmap
  - pip:
    - cellphonedb
```

Download database

```
cellphonedb database list_remote

version v4.0.0 *latest: released: 2022-07-06T12:48:10Z, url: https://github.com/ventolab/cellphonedb-data/releases/tag/v4.0.0, compatible: True
version v3.0.0: released: 2022-06-19T22:10:35Z, url: https://github.com/ventolab/cellphonedb-data/releases/tag/v3.0.0, compatible: True
version v2.0.0: released: 2021-12-21T17:09:48Z, url: https://github.com/ventolab/cellphonedb-data/releases/tag/v2.0.0, compatible: True

```

The version similar to the CCI paper should be v2.0.0 based on the timestamp

```
cellphonedb database download --version v2.0.0

[ ][APP][07/02/23-14:13:13][INFO] Downloading release v2.0.0 of CellPhoneDB database
[ ][APP][07/02/23-14:13:14][INFO] Download completed!
[ ][APP][07/02/23-14:13:14][INFO] Copying database to /home/mcc/.cpdb/releases/v2.0.0
```

```
ls /home/mcc/.cpdb/releases/v2.0.0
cellphone.db  data  metadata.json
```



## 2. CCI code repo

### 2.1 Config CCI repo :rocket:

Scripts need to be modified in order to run on the server. Currently, the following changes are needed:

1. `prepare_dir_script.py`: changed the scripts path and only include `CellChat`, `Giotto` and `cellphonedbv3` for testing.
2. ...

**Skip** :arrow_down:

```
# curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
# sudo apt-get install git-lfs
```

```
# Need to download the archived package to include the git lfs
unzip CCI-main.zip
```

```
git clone https://github.com/wanglabtongji/CCI.git
```

The `prepare_dir_script.py` need to be modified for the directory and the tools for benchmark. I included only CellChat, Giotto and cellphonedbv3 for testing.

**Skip** :arrow_up:

###  2.2 Test run tools

The following script will prepare the test environment for each CCI tools. 

The `prepare_dir_scripts.py` needs to be updated:

1. the path to the `scripts/`
2. add cellphonedb v3 test
3. update the cellphonedb path to `/home/mcc/.cpdb/releases/v2.0.0/cellphone.db`

```
cd ~/CCI-main/example_data

python ../scripts/prepare_dir_script.py --sc_norm ./ST_A3_GSM4797918/data/processed/sc_norm.tsv --sc_count ./ST_A3_GSM4797918/data/processed/sc_counts.tsv --sc_meta ./ST_A3_GSM4797918/data/processed/sc_meta.tsv --deconv ./ST_A3_GSM4797918/data/STRIDE/STRIDE_spot_celltype_frac.txt --st_count ./ST_A3_GSM4797918/data/processed/st_counts.tsv --st_coord ./ST_A3_GSM4797918/data/processed/st_coord.tsv --st_meta ./ST_A3_GSM4797918/data/processed/st_meta.tsv --output_dir ./ST_A3_GSM4797918/tools
```

#### 2.2.1 CellChat

```
conda activate RENV
```

```
# manually run R scripts
cd ~/CCI-main/example_data/ST_A3_GSM4797918
Rscript ~/CCI-main/scripts/run_cc.R -c ././data/processed/sc_norm.tsv -m ././data/processed/sc_meta.tsv -o ././tools/cc/output/
```

Benchmark can also be executed with the scripts generated with `prepare_dir_script.py`.

Recommended :+1:

```
# run with the provided bash scripts
cd ~/CCI-main/example_data/ST_A3_GSM4797918 && bash ST_A3_GSM4797918/tools/cc/script/submit_cc.sh
```



#### 2.2.2 Giotto

Not able to test Giotto as the `ST_A3_GSM4797918/data/processed/sc_counts.tsv` file is not available to download!

#### 2.2.3 CellPhoneDB V3

```
conda activate cpdb_latest
```

```
# manually run R scripts
cd ~/CCI-main/example_data/ST_A3_GSM4797918
cellphonedb method statistical_analysis ././data/processed/sc_meta.tsv ././data/processed/sc_norm.tsv --counts-data gene_name --output-path ././tools/cpdb_v3/output --threads 4 --database /home/mcc/.cpdb/releases/v2.0.0/cellphone.db
```

```
# run with the provided bash scripts
cd ~/CCI-main/example_data/ST_A3_GSM479791
```



