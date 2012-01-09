import java.util.Scanner;

/**
 * User: Geoff
 * Date: 12/16/11
 * Time: 2:54 AM
 * 
 * This class implements the priority queue using a heap. In order to 
 * replicate the pseudo code as much as possible, I am using an array
 * that is 1 indexed. Thus I have a default value at the zero index. 
 */
public class Heap {
  private int[] H;
  private int N; // max size
  private int n; // current size
  
  /**
   * Reads in the input and executes the program. 
   * @param args 
   */
  public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    Heap myheap = new Heap(sc.nextInt());
    while(sc.hasNext()) {
      String s = sc.next();
      if(s.equals("D")) {
        myheap.delete(1);
      }
      else {
        myheap.add(Integer.parseInt(s));
      }
      myheap.print();
    }
  }
  
  /**
   * Makes a new heap of a given size. Again, the heap is 1 indexed.
   * @param size The size of the heap
   */
  public Heap(int size) {
    // we're going to 1 index, so I will not be using H[0]
    H = new int[size+1];
    this.N = size;
    this.n = 0;
  }
  
  /**
   * Returns the left child of the node specified.
   * @param i The node
   * @return The left child of the node
   */
  public int leftChild(int i) {
    return 2*i;
  }
  
  /**
   * Returns the right child of the node specified.
   * @param i The node
   * @return The right child of the node
   */
  public int rightChild(int i) {
    return 2*i + 1;
  }
  
  /**
   * Returns the parent of the node specified.
   * @param i The node
   * @return The parent of the node
   */
  public int parent(int i) {
    return i/2;
  }
  
  /**
   * Adds an value to the heap and reorders it accordingly.  
   * @param v The value to add
   */
  public void add(int v) {    if(n < N) {
      int i = n + 1;
      H[i] = v;
      heapifyup(i);
      n = n + 1;
    }
  }
  
  /**
   * Reorders the heap from the specified node. It swaps the child and the 
   * parent if necessary and reorders from the parent.
   * @param i The node to start at
   */
  public void heapifyup(int i) {
    if(i > 1) {
      int j = parent(i);
      if(H[i] < H[j]) {
        swap(i,j);
        heapifyup(j);
      }
    }
  }
  
  /**
   * Swaps the values at the specified positions
   * @param i First position
   * @param j Second position
   */
  public void swap(int i, int j) {
    int temp = H[i];
    H[i] = H[j];
    H[j] = temp;
  }

  /**
   * Removes the node at the specified position and reorders. 
   * @param i The node to delete
   */
  public void delete(int i) {
    if(n > 0) {
      H[i] = H[n];
      n = n - 1;
      heapifydown(i);
    }
  }

  /**
   * Reorders the heap from the given position. If we are out of range, we stop.
   * Otherwise if we are below the range, we reorder accordingly.
   * @param i The node to being from
   */
  public void heapifydown(int i) {
    int j = -1;
    if(2*i > n) {
      return;
    }
    else if(2*i < n) {
      int left = leftChild(i);
      int right = rightChild(i);
      j = right;
      if(H[left] < H[right]) {
        j = left;
      }
    }
    else if(2*i == n) {
      j = 2*i;
    }
    if(H[j] < H[i]) {
      swap(i,j);
      heapifydown(j);
    }
  }
  
  /**
   * Prints out the heap.
   */
  public void print() {
    String s = "";
    for(int i = 1; i <= n; i++) {
      s += H[i] + " ";      
    }
    System.out.println("> " + s.trim());
  }
}
