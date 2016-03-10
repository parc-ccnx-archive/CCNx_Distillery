
## Run the simple file transfer check. 
sanity-filetransfer:
	tools/bin/sanityCheck-FileTransfer.py ${CCNX_HOME}/bin


sanity: sanity-filetransfer
