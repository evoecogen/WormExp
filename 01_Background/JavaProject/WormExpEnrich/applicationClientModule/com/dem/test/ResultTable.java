package com.dem.test;
import java.io.Serializable;
import java.util.ArrayList;
public class ResultTable implements
Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private ArrayList <String> [] overlapID=null;
	private ArrayList <String> [] uID1=null;
	private ArrayList <String> [] uID2=null;
	
	private String [] setName=null;
	private Integer [] counts=null;
	private Integer[] nset=null;
	private int popsize,setsize;
	private Double [] pvalue=null;
	private Double [] bonferroni=null;
	private Double [] bh=null;
	private Integer [] index=null;
	private String [] category=null;
	private String [] ref=null;
	private String [] infos=null;
	private ArrayList <String> colnames=null;
	private ArrayList <String> rownames=null;
	private Integer [][] indicator=null;
	private int testsize=0;
	private Boolean vterms=false;
	private String singleref=null;
	public void setRefs(String [] refs)
	{
		this.ref=refs;
	}
	public void setSingleref(String ref)
	{
		this.singleref=ref;
	}
	public String getSingleref()
	{
		return this.singleref;
	}
	public void setColnames(ArrayList <String> colnames)
	{
		this.colnames=colnames;
	}
	public void setVterms(Boolean vterms)
	{
		this.vterms=vterms;
	}
	public void setRownames(ArrayList <String> rownames)
	{
		this.rownames=rownames;
	}
	public void setIndicators(Integer [][] indicators)
	{
		this.indicator=indicators;
	}
	public String[] getInfos()
	{
		return this.infos;
	}
	public String[] getRefs()
	{
		return this.ref;
	}
	public ArrayList <String> getColnames()
	{
		return this.colnames;
	}
	public ArrayList <String> getRownames()
	{
		return this.rownames;
	}
	public Integer[][] getIndicator()
	{
		return this.indicator;
	}
	public void setTestSize(int tsize)
	{
		this.testsize=tsize;
	}
	public void setInfos(String [] infos)
	{
		this.infos=infos;
	}
	public void setCategory(String [] cate)
	{
		this.category=cate;
	}
	public void setOverlapID(ArrayList <String> [] verid)
	{
		this.overlapID=verid;
	}
	public void setuID1(ArrayList <String> [] verid)
	{
		this.uID1=verid;
	}
	public void setuID2(ArrayList <String> [] verid)
	{
		this.uID2=verid;
	}
	public void setSizeofSet(Integer [] ss)
	{
		this.nset=ss;
	}
	public void setSetname(String [] sn)
	{
		this.setName=sn;
	}
	public void setCounts(Integer [] cs)
	{
		this.counts=cs;
	}
	public void setPopsize(int ps)
	{
		this.popsize=ps;
	}
	public void setSetsize(int ss)
	{
		this.setsize=ss;
	}
	public void setPvalue(Double [] pv)
	{
		this.pvalue=pv;
	}
	public void setBonferroni(Double [] bf)
	{
		this.bonferroni=bf;
	}
	public void setBH(Double [] bh)
	{
		this.bh=bh;
	}
	public void setIndex(Integer [] index)
	{
		this.index=index;
	}
	public ArrayList <String> [] getOverlapID()
	{
		return this.overlapID;
	}
	public ArrayList <String> [] getuID1()
	{
		return this.uID1;
	}
	public ArrayList <String> [] getuID2()
	{
		return this.uID2;
	}
	public Integer[] getCounts()
	{
		return this.counts;
	}
	public int getPopsize()
	{
		return this.popsize;
	}
	public Boolean getVterms()
	{
		return this.vterms;
	}
	public int getSetsize()
	{
		return this.setsize;
	}
	public Double[] getPvalue()
	{
		return this.pvalue;
	}
	public Double[] getBonferroni()
	{
		return this.bonferroni;
	}
	public Double[] getBH()
	{
		return this.bh;
	}
	public String[] getSetname()
	{
		return this.setName;
	}
	public Integer[] getSizeofSet()
	{
		return this.nset;
	}
	public Integer[] getIndex()
	{
		return this.index;
	}
	public int getTestSize()
	{
		return this.testsize;
	}
	public String[] getCategory()
	{
		return this.category;
	}
}
