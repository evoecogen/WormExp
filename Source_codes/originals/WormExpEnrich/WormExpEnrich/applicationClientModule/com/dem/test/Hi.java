package com.dem.test;

import java.io.*;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.*;

import com.dem.stat.*;

public class Hi extends UnicastRemoteObject implements WEInterface {
 
	private Set<String> showid =new HashSet <String> ();
	private LinkedHashMap<String, HashMap<String, Object>> datastat= new LinkedHashMap();
	
	//id 
	private LinkedHashMap<String, String []> wid = new LinkedHashMap();
	private LinkedHashMap<String, String []> seq2w = new LinkedHashMap();
	private LinkedHashMap<String, String []> sym2w = new LinkedHashMap();
	//data matrix
	private LinkedHashMap<String, Integer> dbuf = new LinkedHashMap();
	private List<List<Integer>> ddata= new ArrayList(); 
	private List<LinkedHashMap<String,Boolean>> setindexdata= new ArrayList(); 

	
	///category
	private LinkedHashMap<String, Integer> setbuf = new LinkedHashMap();
	private List<Set<Integer>> setdata= new ArrayList(); 
	
	//data set name
	private LinkedHashMap<String, Integer> nbuf = new LinkedHashMap();
	private List<Integer> ndata=new ArrayList();
	
	//category path and information
	private String idfile,reffile;
	private LinkedHashMap<String, String> datfile = new LinkedHashMap();
	private LinkedHashMap<String, String> datname = new LinkedHashMap();
	private LinkedHashMap<String, String> catname = new LinkedHashMap();
	private int indw,inds;
	
	//reference
	private LinkedHashMap<String, String> reference = new LinkedHashMap();


	private ResultTable clusm= new ResultTable();



	/*
	 * output data
	 */

	
	public Hi(String msg) throws RemoteException {
		super();
		System.out.println("Initializing...");
		try {
			loading();
			//System.out.println(indw+"\t"+inds);
			//System.out.println(wid.size()+"\t"+seq2w.size()+"\t"+sym2w.size());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String message = msg + " I am on server....";
	}
	@Override
	public ResultTable search(String setname) throws RemoteException
	{
		ResultTable rt=new ResultTable();
		//System.out.println(setname);
		if(!nbuf.containsKey(setname)) return null;
		else{
			int index=nbuf.get(setname);
			LinkedHashMap<String,Boolean> rowc=setindexdata.get(index);
			int sizes=rowc.size(),sindex=0;
			String [] wormID=new String[sizes];
			String [] gname= new String[sizes];
			for(String ss:rowc.keySet())
			{
				wormID[sindex]=ss;
				String [] lineVariables=wid.get(ss);
				if(lineVariables.length>1 && lineVariables[1].length()!=0)
				{
					gname[sindex]=lineVariables[1];
					//sym2w.put(lineVariables[1], lineVariables);
				}
				else if(lineVariables.length>2)
				{
					gname[sindex]=lineVariables[2];
					//seq2w.put(lineVariables[2],lineVariables);
				}else
				{
					gname[sindex]=ss;
				}
				sindex++;
			}
			rt.setSingleref(reference.get(setname));
			rt.setSetname(wormID);
			rt.setRefs(gname);
			return rt;
		}
	}
	@Override
	public LinkedHashMap<String, ResultTable> analysis(ArrayList<ArrayList<String>> glist, String [] dataset, List <String> background) throws RemoteException {
		
		//results table
		LinkedHashMap<String, ResultTable> rt = new LinkedHashMap();
		
		int setsize=ndata.size(), popsize=ddata.size();
		//for(int i=0;i<dataset.length;i++) System.out.println(dataset[i]);
		Integer [] totsize=new Integer[setsize];
		if(background==null)
		{
			ndata.toArray(totsize);
		}else
		{
			ArrayList <String> tlst1 = new ArrayList(),tlst2 = new ArrayList();
			for(int i=0;i<glist.get(0).size();i++)
			{
				String s=glist.get(0).get(i);
				if(background.contains(s))
				{
					tlst1.add(s);
					tlst2.add(glist.get(1).get(i));
				}
			}
			glist.set(0, tlst1);
			glist.set(1, tlst2);
			Arrays.fill(totsize, 0);
			for(String s: background)
			{
				if(dbuf.containsKey(s))
				{
					int index=dbuf.get(s);
					//System.out.println(s+"\t"+index);
					List<Integer> ddbuf=ddata.get(index);
					for(Integer si:ddbuf)
					{
						totsize[si]++;
					}
				}
			}
			popsize=background.size();
		}
		
		Integer [] counts=new Integer[setsize];
		ArrayList<String> [] overlapID= new ArrayList [setsize];
		ArrayList<String> [] uniID1= new ArrayList [setsize];
		ArrayList<String> [] uniID2= new ArrayList [setsize];
		Arrays.fill(counts, 0);
		for(int i=0;i<setsize;i++)
		{
			ArrayList <String> sbufs=new ArrayList();
			ArrayList <String> cbufs=new ArrayList();
			ArrayList <String> dbufs=new ArrayList();
			overlapID[i]=sbufs;
			uniID1[i]=cbufs;
			uniID2[i]=dbufs;
		}
		
		int is=0;
		ArrayList <String> idlist1=glist.get(0), idlist2=glist.get(1);
		//determine overlapp
		Boolean [] setbool=new Boolean[setsize];
		
		for(String s: idlist1)
		{
			//#System.out.println(s);
			if(dbuf.containsKey(s))
			{
				Arrays.fill(setbool, false);
				int index=dbuf.get(s);
				//System.out.println(s+"\t"+index);
				List<Integer> ddbuf=ddata.get(index);
				String ss=idlist2.get(is);
				//System.out.println(ss+"\t"+index);
				for(Integer si:ddbuf)
				{
					counts[si]++;
					overlapID[si].add(ss);
					//System.out.println(si);
					setindexdata.get(si).put(s, true);
					//System.out.println(si);
					setbool[si]=true;
					//if(overlapID[si]=="") overlapID[si]+=(ss);
					//else overlapID[si]+=("; "+ss);
				}
				for(int ii=0;ii<setsize;ii++)
				{
					if(!setbool[ii]) uniID1[ii].add(ss);
				}
			}
			is++;
		}
		//get unique id for target set
		for(int ii=0;ii<setsize;ii++)
		{
			LinkedHashMap<String,Boolean> rowc=setindexdata.get(ii);
			for(String ss:rowc.keySet())
			{
				if(!rowc.get(ss))
				{
					String [] lineVariables=wid.get(ss);
					if(lineVariables.length>1 && lineVariables[1].length()!=0)
					{
						uniID2[ii].add(lineVariables[1]);
						//sym2w.put(lineVariables[1], lineVariables);
					}
					else if(lineVariables.length>2)
					{
						uniID2[ii].add(lineVariables[2]);
						//seq2w.put(lineVariables[2],lineVariables);
					}else
					{
					
						//System.out.println(ss);
						uniID2[ii].add(ss);
					}
					//cc++;
				}
				
			}
			//if (aa>1400&&aa<1450)System.out.println("\t"+cc);
		}
		Set <String> nameset=nbuf.keySet();
		
		String [] totname=new String[setsize];
		nameset.toArray(totname);

		ResultTable rts=getResults(dataset,idlist1.size(),popsize,counts,overlapID,uniID1,uniID2,totname,totsize);
		rt.put("org", rts);
		
		
		return rt;
	}
	//get result 
	private ResultTable getResults(String [] dataset,int listsize, int popsize, Integer[] counts,
			ArrayList<String>[] overlapID, ArrayList<String>[] uniID1,
			ArrayList<String>[] uniID2, String[] totname, Integer[] totsize) {
		ResultTable rt=new ResultTable();
		FisherR ft=new FisherR();
		int m,n,k,x,l=listsize;//idlist1.size();
		//R.phyper(-1, 476+832, 5639+16557, 152+5963, false,false)
		List <Integer> indexbuf= new ArrayList();
		List <String> categories= new ArrayList();
		LinkedHashMap<Integer, Integer> tempcat = new LinkedHashMap();
		/*
		 * data set filter
		 */
		if(dataset==null)
		{
			dataset=new String[showid.size()];
			showid.toArray(dataset);
		}
		int tnindex=0;
		for(int i=0;i<dataset.length;i++)
		{
			if(setbuf.containsKey(dataset[i]))
			{
				int j=setbuf.get(dataset[i]);
				String cate=datname.get(dataset[i]);
				for(int ik:setdata.get(j))
				{
					indexbuf.add(ik);
					categories.add(cate);
					if(tempcat.containsKey(ik))
					{
						int tempindex=tempcat.get(ik);
						categories.add(tempindex,categories.get(tempindex)+";"+cate);
					}else tempcat.put(ik, tnindex);
					tnindex++;
				}
			}
		}
		//get size
		
		int newsize=indexbuf.size();
		Integer [] realcounts= new Integer[newsize];
		Double [] pvalue=new Double[newsize];
		ArrayList <String> [] realoverlapID= new ArrayList [newsize];
		ArrayList <String> [] realuniID1= new ArrayList [newsize];
		ArrayList <String> [] realuniID2= new ArrayList [newsize];
		String [] realnames= new String [newsize];
		String [] reflink= new String [newsize];
		Integer [] realsize=new Integer[newsize];
		String [] realcate=new String [newsize];
		categories.toArray(realcate);

		
		for(int j=0;j<newsize;j++)
		{
			int i=indexbuf.get(j);
			int gs=totsize[i],c1=counts[i]-2, c2=l-c1,c3=gs-c1, c4=popsize-l-gs+c1;
			realcounts[j]=counts[i];
			realoverlapID[j]=overlapID[i];
			realuniID1[j]=uniID1[i];
			realuniID2[j]=uniID2[i];
			
			x=c1;
			m=c1+c3;
			n=c2+c4;
			k=c1+c2;
			pvalue[j]=ft.phyper(x, m, n, k, false, false);
			realnames[j]=totname[i];
			realsize[j]=totsize[i];
			if(reference.containsKey(realnames[j])) reflink[j]=reference.get(realnames[j]);
			else
			{
				System.out.println(realnames[j]+" doesn't have a reference!");
			}
			//System.out.println(c1+"\t"+gs+"\t"+pvalue[j]+"\t"+l+"\t"+m+"\t"+n+"\t"+k);
		}
		pAdjustMethod pmbf=new pAdjustMethod(pvalue,"Bonferroni");
		pAdjustMethod pmbh=new pAdjustMethod(pvalue);
		rt.setIndex(pmbf.getIndex());
		rt.setBH(pmbh.getAdjPvalue());
		rt.setBonferroni(pmbf.getAdjPvalue());
		rt.setCounts(realcounts);
		rt.setTestSize(l);
		rt.setOverlapID(realoverlapID);
		rt.setuID1(realuniID1);
		rt.setuID2(realuniID2);
		rt.setPvalue(pvalue);
		rt.setPopsize(popsize);
		rt.setSetsize(newsize);
		
		//Set <String> nameset=nbuf.keySet();
		rt.setRefs(reflink);
		//nameset.toArray(nambuff);
		rt.setSetname(realnames);
		rt.setCategory(realcate);
		//Integer [] sizebuff=new Integer[setsize];
		//ndata.toArray(sizebuff);
		rt.setSizeofSet(realsize);
		return rt;
	}
	@Override
	public ArrayList<ArrayList<String>> check(List<String> ilist) throws RemoteException {
		//System.out.println(wid.size()+"\t"+seq2w.size()+"\t"+sym2w.size());
		Set <String> glist= new HashSet<String>();
		//glist.addAll(ilist);
		ArrayList<ArrayList<String>> als = new ArrayList<ArrayList<String>> (); 
		als.add(new ArrayList<String> ());//right list
		als.add(new ArrayList<String> ());//right list of raw
		als.add(new ArrayList<String> ());//wrong listerror
		
		for (String s : ilist) {
			  if(wid.containsKey(s)){
				  if(!glist.contains(s))
				  {
				  als.get(0).add(s);
				  als.get(1).add(s);
				  glist.add(s);
				  }
			  }else if(seq2w.containsKey(s)){
				  String ws=seq2w.get(s)[0];
				  if(!glist.contains(ws))
				  {
					 als.get(0).add(ws);
				     als.get(1).add(s);
				     glist.add(ws);
				  }
			  }else if(sym2w.containsKey(s)){
				  String ws=sym2w.get(s)[0];
				  if(!glist.contains(ws))
				  {
					 als.get(0).add(ws);
				     als.get(1).add(s);
				     glist.add(ws);
				  }
			  }else{
				  als.get(2).add(s);
			  }
			}
		return als;
	}


	private void loading() throws IOException {
		loadingProperties();
		System.out.print("Loading ID...");
		loadingID();
		System.out.println("done");
		System.out.print("loading data set...");
		loadingDataset();
		loadingReference();
		for(int indset=0;indset <setdata.size();indset++)
		{
			int catesize=setdata.get(indset).size();
			if(datastat.containsKey(Integer.toString(indset+1)))
			{
				LinkedHashMap<String, Object> tab= (LinkedHashMap<String, Object>) datastat.get(Integer.toString(indset+1));
				tab.put("number", catesize);
				datastat.put(Integer.toString(indset+1), tab);
			}
		}

		//process tf info
		int setsize=ndata.size();
		Set <String> nameset=nbuf.keySet();
		String [] totname=new String[setsize];
		nameset.toArray(totname);
		System.out.println("done");
		/*for(String ss:nbuf.keySet())
		{
			int index=nbuf.get(ss);
			
			System.out.println(ss+"\t"+ndata.get(index));
		}*/

	}
	  private Properties trimProperties(Properties webProperties)
	  {
	    Properties trimProperties = new Properties();
	    for (Map.Entry<Object, Object> property : webProperties.entrySet()) {
	      trimProperties.put(property.getKey(), ((String)property.getValue()).trim());
	    }
	    return trimProperties;
	  }
	private void loadingReference()throws IOException
	{
		FileInputStream fstream = null;
		try {
			fstream = new FileInputStream(reffile);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		BufferedReader br = new BufferedReader(new InputStreamReader(fstream));

		String strLine;

		//Read File Line By Line
		try {
			while ((strLine = br.readLine()) != null)   {
			  // Print the content on the console
				String[] lineVariables = strLine.split("\t");
				reference.put(lineVariables[0], lineVariables[1]);
				if(!lineVariables[2].equals("NA")) 
				{
					String[] additionalCats = lineVariables[2].split(";");
					for(String key: additionalCats)
					{
						if(nbuf.containsKey(lineVariables[0]) && setbuf.containsKey(key))
						{
							int tsetindex=nbuf.get(key),tcatindex=setbuf.get(key);
							setdata.get(tcatindex).add(tsetindex);
						}

					}
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		//Close the input stream
		try {
			br.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private void loadingProperties() throws IOException
	{
		Properties datpro = new Properties();
		FileInputStream fis = new FileInputStream("dat.properties");
		
		datpro.load(fis);
		Properties trimpro=trimProperties(datpro);
		idfile = trimpro.getProperty("idfile");
		if(idfile==null) throw new NullPointerException("There is no idfile in 'dataset.properties'!");
		reffile = trimpro.getProperty("reffile");
		if(idfile==null) throw new NullPointerException("There is no reffile in 'dataset.properties'!");
		
		Properties props = getPropertiesStartingWith("dataset", trimpro);
		
		if (props.size() != 0)
		{
		      props = stripStart("dataset", props);
		      int i = 1;
		      
		      while (props.containsKey(i + ".id"))
		      {
		        String id = (String)props.get(i + ".id"),pathf=(String)props.get(i + ".path"), cate=(String)props.get(i + ".category"), des=(String)props.get(i + ".description"), tem=(String)props.get(i + ".template"), noshow=(String)props.get(i + ".noshow");
		        datfile.put(id, pathf);
		        if(!(noshow!=null&&noshow.equals("true"))) 
		        {
		        	 showid.add(id);
				     LinkedHashMap<String, Object> tab = new LinkedHashMap();
				     tab.put("identifier", id);
				     tab.put("name", cate);
				     tab.put("description", des);
				     tab.put("template", tem);
				     datastat.put(Integer.toString(i), tab);
		        }
		        datname.put(id, cate);
		        catname.put(cate.toLowerCase(), id);
		        i++;
		      }
		    }else{
		    	throw new NullPointerException("There is no dataset in 'dataset.properties'!");
		    }
	}
	  private static Properties getPropertiesStartingWith(String str, Properties props)
	  {
	    if (str == null) {
	      throw new NullPointerException("str cannot be null, props param: " + props);
	    }
	    if (props == null) {
	      throw new NullPointerException("props cannot be null, str param: " + str);
	    }
	    Properties subset = new Properties();
	    Enumeration<Object> propertyEnum = props.keys();
	    while (propertyEnum.hasMoreElements())
	    {
	      String propertyName = (String)propertyEnum.nextElement();
	      if (propertyName.startsWith(str)) {
	        subset.put(propertyName, props.get(propertyName));
	      }
	    }
	    return subset;
	  }
	  private static Properties stripStart(String prefix, Properties props)
	  {
	    if (prefix == null) {
	      throw new NullPointerException("prefix cannot be null");
	    }
	    if (props == null) {
	      throw new NullPointerException("props cannot be null");
	    }
	    Properties ret = new Properties();
	    Enumeration<Object> propertyEnum = props.keys();
	    while (propertyEnum.hasMoreElements())
	    {
	      String propertyName = (String)propertyEnum.nextElement();
	      if (propertyName.startsWith(prefix + ".")) {
	        ret.put(propertyName.substring(prefix.length() + 1), props.get(propertyName));
	      }
	    }
	    return ret;
	  }
	private void loadingID(){
		//read id file
		FileInputStream fstream = null;
		try {
			fstream = new FileInputStream(idfile);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		BufferedReader br = new BufferedReader(new InputStreamReader(fstream));

		String strLine;

		//Read File Line By Line
		try {
			while ((strLine = br.readLine()) != null)   {
			  // Print the content on the console
				String[] lineVariables = strLine.split(",");
				wid.put(lineVariables[0],lineVariables);
				if(lineVariables.length>1 && lineVariables[1].length()!=0)
				{
					sym2w.put(lineVariables[1], lineVariables);
				}
				if(lineVariables.length>2)
				{
					seq2w.put(lineVariables[2],lineVariables);
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		//Close the input stream
		try {
			br.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	private void loadingDataset()
	{
		indw=inds=0;
		int indset=0;
		for(String key: datfile.keySet())
		{
			setbuf.put(key, indset);
			Set<Integer> rowb=new HashSet <Integer> ();
			
			setdata.add(rowb);
			//setindexdata.add(rowc);
			System.out.println(key+"\t"+datfile.get(key));
			loadingDataset(datfile.get(key),indset);
			indset++;
		}
	}
	private void loadingDataset(String name, int id) {
		
		//read id file
		FileInputStream fstream = null;
		try {
			fstream = new FileInputStream(name);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		BufferedReader br = new BufferedReader(new InputStreamReader(fstream));

		String strLine;
		

		//int indw=0,inds=0;

		//Read File Line By Line
		try {
			while ((strLine = br.readLine()) != null)   {
			  // Print the content on the console
				String[] lineVariables = strLine.split("\t");
				if(!wid.containsKey(lineVariables[0]))
				{
					//System.out.println(lineVariables[0]);
					continue;
				}
				if(!nbuf.containsKey(lineVariables[1]))
				{
					nbuf.put(lineVariables[1], inds);
					setdata.get(id).add(inds);
					ndata.add(0);
					LinkedHashMap<String,Boolean> rowc=new LinkedHashMap();
					setindexdata.add(rowc);
					inds++;
				}
				int index=nbuf.get(lineVariables[1]);
				
				ndata.set(index,ndata.get(index)+1);
				if(!dbuf.containsKey(lineVariables[0]))
				{
					dbuf.put(lineVariables[0], indw);
					List<Integer> rowb=new ArrayList();
					ddata.add(rowb);
					indw++;
				}
				int index1=dbuf.get(lineVariables[0]);
				List<Integer> rbuf=ddata.get(index1);
				rbuf.add(index);
				ddata.set(index1, rbuf);
				//data set index
				setindexdata.get(inds-1).put(lineVariables[0], false);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		//Close the input stream
		try {
			br.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		/*String ID="WBGene00000005";
		System.out.println(indw+"\t"+inds);
		int index=dbuf.get(ID);
		List<Integer> ddbuf=ddata.get(index);
		Set <String> nameset=nbuf.keySet();
		for(Integer s:ddbuf)
		{
			System.out.println(nameset.toArray()[s]);
		}
		*/
	}
	@Override
	public LinkedHashMap<String, HashMap<String, Object>> getDataStatistics()
			throws RemoteException {
		return this.datastat;
	}
	@Override
	public ResultTable search(ArrayList<String> keywords,
			ArrayList<ArrayList<String>> glist, Boolean vterms) throws RemoteException {
		ResultTable rt =new ResultTable();
		if (keywords == null) {
		      throw new NullPointerException("keywords cannot be null");
		    }

	    int setsize=ndata.size();
		Boolean [] setindicator=new Boolean[setsize];
		Arrays.fill(setindicator, false);
		
		Set <String> nameset=nbuf.keySet();
		
		String [] totname=new String[setsize];
		nameset.toArray(totname);
		
		
		for(String kw:keywords)
		{
			if(catname.containsKey(kw.toLowerCase()))
			{
				String s=catname.get(kw.toLowerCase());
				int j=setbuf.get(s);
				for(int ik:setdata.get(j))
				{
					setindicator[ik]=true;
				}
			}else if(nbuf.containsKey(kw))
			{
				setindicator[nbuf.get(kw)]=true;
			}else{
				for(String s:totname)
				{
					if(s.toLowerCase().contains(kw.toLowerCase()))
					{
						setindicator[nbuf.get(s)]=true;
					}
				}
			}
		}
		ArrayList <String> colnames=new ArrayList();
		Integer [] indexmap=new Integer[setsize];
		int indexstart=0;
		for(int i=0;i<setsize;i++)
		{
			if(setindicator[i])
			{
				colnames.add(totname[i]);
				indexmap[i]=indexstart;
				indexstart++;
			}
		}
		//show set
		//System.out.println(vterms);
		rt.setVterms(vterms);
		if(vterms)
		{
			int cols=colnames.size(),sindex=0;
			if(cols==0)
			{
				return null;
			}
			Integer [] setcounts=new Integer[cols];
			for(String ss:colnames)
			{
				//System.out.println(ss);
				int index=nbuf.get(ss);
				setcounts[sindex]=ndata.get(index);
				sindex++;
				//System.out.println(ss+"\t"+ndata.get(index));
			}
			rt.setCounts(setcounts);
			rt.setColnames(colnames);
			return rt;
		}
	    if (glist == null || glist.get(0).size()==0) {
		      throw new NullPointerException("gene list cannot be null");
		    }
		ArrayList <String> idlist1=glist.get(0), rownames=glist.get(1);
		int colsize=colnames.size(),rowsize=rownames.size();
		if(colsize==0)
		{
			return null;
		}
		Integer [][] indicators=new Integer[rowsize][colsize];
		for(int i=0;i<rowsize;i++)
		{
			for(int j=0;j<colsize;j++) indicators[i][j]=0;
		}
		indexstart=0;
		for(String s: idlist1)
		{
			if(dbuf.containsKey(s))
			{
				int index=dbuf.get(s);
				//System.out.println(s+"\t"+index);
				List<Integer> ddbuf=ddata.get(index);
				for(Integer si:ddbuf)
				{
					if(setindicator[si]) indicators[indexstart][indexmap[si]]=1;
				}
			}
			indexstart++;
		}
		rt.setIndicators(indicators);
		rt.setRownames(rownames);
		rt.setColnames(colnames);
		return rt;
	}
}