package com.dem.test;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
//����Զ�̽ӿڼ�����Զ�̷���
public interface WEInterface extends Remote {
	  /**    
	    * Զ�̽ӿڷ��������׳� java.rmi.RemoteException    
	    */    
	   public ArrayList<ArrayList<String>> check(List<String> glist) throws RemoteException;
	   public ResultTable search(ArrayList<String> keywords, ArrayList<ArrayList<String>> glist, Boolean vterms) throws RemoteException;
	   public ResultTable search(String setname) throws RemoteException;
	   public LinkedHashMap<String, HashMap<String, Object>> getDataStatistics() throws RemoteException;
	   public LinkedHashMap<String, ResultTable> analysis(ArrayList<ArrayList<String>> glist, String[] dataset,
			List<String> background) throws RemoteException;
}
