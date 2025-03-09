#!/route/miniconda3/envs/R/bin/Rscript

files_in <- "
/route/RNA/Triticum_durum/G5/counts/pair/counts_pair.txt"

files_out_fpkm <- "
/route/fpkm/Triticum_durum_G5_pair_fpkm.csv
"
files_out_tpm <- "
/route/tpm/Triticum_durum_G5_pair_tpm.csv
"

file_in <- unlist(strsplit(files_in, "\n"))
files_out_fpkm <- unlist(strsplit(files_out_fpkm, "\n"))
files_out_tpm <- unlist(strsplit(files_out_tpm, "\n"))

for (i in 1:10){
	path <- file_in[i]
	count <- read.table(path, header = T,sep="\t")
	rownames(count) <- count[ ,1]
	count <- count[ ,-1]         
	count <- count[ ,5:ncol(count)]  

	# TPM
	kb <- count[,1] / 1000
	# 括号中是需要统计的count列数
	countdata <- count[ ,2:ncol(count)]
	rpk <- countdata / kb
	# TPM
	tpm <- t(t(rpk) / sum(rpk) * 1000000)
	write.table(tpm, file = files_out_tpm[i], sep = "\t", quote = F)

	# FPKM
	fpkm <- t(t(rpk)/sum(countdata) * 10^6)
	head(fpkm)
	write.table(fpkm, file = files_out_fpkm[i], sep = "\t", quote=F)
}
