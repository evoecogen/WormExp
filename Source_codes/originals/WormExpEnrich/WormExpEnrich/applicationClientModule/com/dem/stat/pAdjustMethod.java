package com.dem.stat;

import java.util.Arrays;
import java.util.List;

public class pAdjustMethod {
	private Double [] p0;
	private Integer [] pindex;
	public pAdjustMethod(Double [] p,String method)
	{
		calIndex(p);
		if(method=="BH"){
			this.BH(p);
		}else if(method=="Bonferroni")
		{
			this.Bonferroni(p);
		}else
		{
			throw new IllegalArgumentException("Invalid p-value adjustment method.");
		}
	}
	public pAdjustMethod(Double [] p)
	{
		this(p,"BH");
	}
	public class Pair implements Comparable<Pair> {
	    public final int index;
	    public double value;

	    public Pair(int index, double value) {
	        this.index = index;
	        this.value = value;
	    }

	    @Override
	    public int compareTo(Pair other) {
	        //multiplied to -1 as the author need descending sort order
	        return 1 * Double.valueOf(this.value).compareTo(other.value);
	    }
	}
	private void BH(Double [] p)
	{
		p0=p.clone();
		int n= p.length;
		Pair [] pbuf = new Pair[n];
		
		for( int k=0;k<n;k++)
		{
			pbuf[k]=new Pair(k,p[k]);
		}
		Arrays.sort(pbuf);

		double pmin=1;
	    //use the same procedure as p.adjust(...,"BH") in R
		for (int k = n-1; k >= 0; k--)
		{
			double corrected_p = (double) pbuf[k].value * ((double) n/(double) (k+1));
	        //make sure that no entry with lower p-value will get higher q-value than any entry with higher p-value
			if (corrected_p < pmin) 
			{
				pmin = corrected_p;
			}
			else
			{
				corrected_p = pmin;
			}
			//cout<<corrected_p<<endl;
	        // make sure that the q-value is always <= 1 
			p0[pbuf[k].index]= corrected_p < 1 ? corrected_p : 1; 
			//cout<<tests[k]->advalue<<endl;
		}
		
	}
	private void calIndex(Double [] p)
	{
		int n= p.length;
		Pair [] pbuf = new Pair[n];
		pindex= new Integer[n];
		for( int k=0;k<n;k++)
		{
			pbuf[k]=new Pair(k,p[k]);
		}
		Arrays.sort(pbuf);
		for(int k=0;k<n;k++)
		{
			pindex[k]=pbuf[k].index;
		}
	}
	private void Bonferroni(Double [] p)
	{
		p0=p.clone();
		int n=p.length;
		for(int i=0;i<n;i++){
			double pbuf=p0[i]*n;
			if(pbuf>1.0) pbuf=1.0;
			p0[i]=pbuf;
		}
	}
	public Double [] getAdjPvalue()
	{
		return p0;
	}
	public Integer[] getIndex()
	{
		return this.pindex;
	}
}
