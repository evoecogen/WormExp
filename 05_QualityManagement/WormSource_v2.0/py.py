import sys
import re
def doit(filename):
    try:
        file=open(filename,'r')
    except:
        print('Error! Cannot open the file '+filename+'!Please check it!')
        sys.exit(0);
    le="WBGene"
    mid="00000000000000"
    lenz=14
    fout=open(filename+".re.txt","w")
    for line in file:
        buff=re.split('\t',line.strip())
        if buff[1]=="Tissue-specific else":
            continue
        len1=len(buff[0])
        len2=lenz-6-len1
        fout.write(le+mid[:len2]+buff[0]+"\t"+buff[1]+"\n")
    fout.close()
def main():
    if len(sys.argv)==1:
        print('usage:\n'+'\t[-F|filename,must be in eland format!]\n')
        return
    argF=50
    for i in range(len(sys.argv)):
        if sys.argv[i]=="-F":
           argF=i+1
    if argF>=len(sys.argv):
        print('usage:\n\t[-F|treat filename,must be in bed format!]\n')
        return;
    tfilename=sys.argv[argF]
    doit(tfilename)
if __name__ == '__main__' :
    main()
