package com.dem.test;


import java.rmi.Naming;
import java.rmi.registry.LocateRegistry;
 
//����RMIע����񣬲�ע��Զ�̶���HiServer.java��
public class HiServer {
 
	 public static void main(String[] argv)     
	   {     
	      try    
	      {     
	         //����RMIע�����ָ���˿�Ϊ1099����1099ΪĬ�϶˿ڣ�     
	         //Ҳ����ͨ������ ��java_home/bin/rmiregistry 1099����     
	         //���������ַ�ʽ�������ٴ�һ��DOS����     
	         //����������rmiregistry����ע����񻹱���������RMIC����һ��stub��Ϊ������     
	         LocateRegistry.createRegistry(1099);     
 
	         //����Զ�̶����һ������ʵ����������hello����     
	         //�����ò�ͬ����ע�᲻ͬ��ʵ��     
	         WEInterface hi = new Hi("Hello, world!");     
 
	         //��hiע�ᵽRMIע��������ϣ�����ΪA
	         Naming.rebind("A", hi);     //�ͻ���ͨ�����A��Ѱ��
 
	         //���Ҫ��hiʵ��ע�ᵽ��һ̨������RMIע�����Ļ�����     
	         //Naming.rebind("//192.168.1.105:1099/A",hi);     
 
	         System.out.println("Hi Server is ready.");     
	      }     
	      catch (Exception e)     
	      {     
	         System.out.println("Hi Server failed: " + e);     
	      }     
	   }     
 
}
