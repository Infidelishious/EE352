import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Scanner;

import javax.swing.JFileChooser;


public class CacheSim {

	public static int HIT_TIME = 1;
	
	CacheSim thiss;
	Scanner in;
	
	int lineSize, 
		associtivity, 
		cachekb, 
		misspen, 
		cacheSize,
		hits = 0,
		misses = 0;
	
	long[] cacheTags;
	long[] cacheTime;
	
	boolean direct;
	
	public CacheSim(){
		thiss = this;
		//System.out.println("Cache Sim\nCache takes = ");
		in = new Scanner(System.in);
		lineSize = getIntP2("Line Size (Must Be grater than 4): ", false) / 4;
		if(lineSize < 1)
		{
			System.out.println("no");
			return;
		}
		
		associtivity = getInt("Associativity (1 = associtive, 2 = direct map): ", 1,2, false);	
		direct = (associtivity == 2);
		
		System.out.println("Direct = " + direct);
			
		cachekb = getIntP2("Data Size (kb): ", false);
		misspen = getInt("Miss Penulty: ", 1, 100, false);
		
		cacheSize = (1028 * cachekb)/(lineSize);
		cacheTags = new long[cacheSize];
		cacheTime = new long[cacheSize];
		
		for(int i = 0; i < cacheSize; i++)
		{
			cacheTags[i] = -1;
			cacheTime[i] = 0;
		}
		
		openTrace();
	}

	
	long addressToTag(long ad)
	{
		long tag = ad / lineSize;
		return tag * lineSize;
	}
	
	boolean isAdressInTag(long ad, long tag)
	{
		return addressToTag(ad) == tag;
	}
	
	private void openTrace() {
		JFileChooser fileChooser = new JFileChooser();
		fileChooser.setDialogTitle("Open");   
		 
		File workingDirectory = new File(System.getProperty("user.dir"));
		fileChooser.setCurrentDirectory(workingDirectory);
		
		int userSelection = fileChooser.showOpenDialog(fileChooser);
		 
		if (userSelection == JFileChooser.APPROVE_OPTION) {
		    File fileToOpen = fileChooser.getSelectedFile();
		    
		    try {
				
		    	System.out.println("Opened file: " + fileToOpen.getAbsolutePath());
				trace(fileToOpen.getAbsolutePath());
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	private void trace(String path) throws IOException {
		  byte[] encoded = Files.readAllBytes(Paths.get(path));
		  String st = new String(encoded, StandardCharsets.UTF_8);
		  String[] traces = st.split("\n", -1);
		  
		  for(int i = 0; i < traces.length; i++)
		  {
			  long address = stToLong(traces[i]);
			  
			  //System.out.println(traces[i] + " (" + address + ")");
			  //System.out.println("TAG" + addressToTag(address));
			  
			  boolean hit = false;
			  
			  for(int j = 0; j < cacheTags.length; j++)
			  {
				  if(cacheTags[j] != -1 && isAdressInTag(address, cacheTags[j]))
				  {
					  hit = true;
					  break;
				  }
			  }
			  
			  if(hit)
			  {
				  hits++;
			  }
			  else
			  {
				  misses++;
				  
				  if(direct)
				  {
					  cacheTags[(int) (addressToTag(address) % cacheSize)] = addressToTag(address);
				  }
				  else
				  {
					  int target = findOldest();
					  cacheTime[target] = 0;
					  cacheTags[target] = addressToTag(address);
					  incTime(); 
				  }
			  }
		  }
		  
		  System.out.println("\nTotal Hit Rate: " + (hits/(float)(hits + misses)));
		  System.out.println("Total Run Time: " + (hits * HIT_TIME +  misses * misspen));
		  System.out.println("Average Memory Access Latency: " + (hits * HIT_TIME +  misses * misspen)/(float)(hits + misses));
	}

	private int findOldest() {
		long v = 0;
		int p = 0;
		
		for(int i = 0; i < cacheSize; i++)
		{
			if(cacheTime[i] > v)
			{
				v = cacheTime[i];
				p = i;
			}
		}
		
		return p;
	}
	
	private void incTime() {
		for(int i = 0; i < cacheSize; i++)
		{
			cacheTime[i]++;
		}
	}

	long stToLong(String st)
	{
		return Long.parseLong(st.substring(2), 16);
	}

	int getIntP2(String prompt, boolean endline)
	{
		System.out.print(prompt);
		int temp;
		while(true)
		{
			try
			{
				temp = in.nextInt();
				if(temp <= 0)
				{
					System.out.println("That is not an option. Please try again");
					continue;
				}
				else if((temp & (temp -1)) != 0)
				{
					System.out.println("That is not an option. Please try again");
					continue;
				}
				
				in.nextLine();
				
				if(endline)
					System.out.println();
				break;
			}
			catch(Exception c)
			{
				in.nextLine();
				System.out.println("Error, not a number. Please try again");
			}
		}

		return temp;
	}
	
	int getInt(String prompt, int min, int max, boolean endline)
	{
		System.out.print(prompt);
		int temp;
		while(true)
		{
			try
			{
				temp = in.nextInt();
				if(temp <= 0)
				{
					System.out.println("That is not an option. Please try again");
					continue;
				}
				else if(temp > max || temp < min)
				{
					System.out.println("That is not an option. Please try again");
					continue;
				}
				
				in.nextLine();
				
				if(endline)
					System.out.println();
				break;
			}
			catch(Exception c)
			{
				in.nextLine();
				System.out.println("Error, not a number. Please try again");
			}
		}

		return temp;
	}
	
	public static void main(String[] args)
	{
		new CacheSim();
	}
}
