screen -x icellnet -p 0 -X stuff "cd /fs/home/liuzhaoyang/project/cci_evaluation/human_intestinal/ST_A3_GSM4797918 && nohup time -v Rscript /fs/home/liuzhaoyang/project/cci_evaluation/scripts/run_icellnet_refine.R -c ./data/processed/sc_norm.tsv -m ./data/processed/sc_meta.tsv -o ./tools/icellnet/output/ > ./tools/icellnet/script/icellnet_nohup.out 2>&1 &\n"