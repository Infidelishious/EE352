import java.util.ArrayList;
import java.util.Scanner;


public class CacheSim {

	public static int HIT_TIME = 1,
						MISS_TIME = 5;
	
	Scanner in;
	int lineSize, associtivity, cachekb, misspen, cacheSize;
	
	long[] cacheTags;
	
	public CacheSim(){
		System.out.println("Cache Sim\nCache takes = ");
		in = new Scanner(System.in);
		lineSize = getIntP2("Line Size:", true);
		associtivity = getInt("Associativity (1 = no, 2 = yes):", 1,2, true) - 1;
		cachekb = getIntP2("Data Size (kb):", true);
		misspen = getInt("Miss Penulty:", 1,2, true) - 1;
		//Long.parseLong("AA0F245C", 16);
		
		cacheSize = (1028 * cachekb)/lineSize;
		cacheTags = new long[cacheSize];
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
