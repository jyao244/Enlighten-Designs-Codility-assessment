class Solution {
    public int solution(int[] A) {
        int len = A.length;
        int result = 0;
        int count = 0;
        int[] moves = new int[len];
        
		for (int i = 0; i < len; i++) {
            count += A[i];
        }
        
		if (count != 10 * len) {
            return -1;
        }
        
		for (int i = 0; i < len; i++) {
            int diff = A[i] - 10;
            if (i > 0) {
                moves[i] = moves[i - 1] + diff;
            } else {
                moves[i] = diff;
            }
        }
        
		for (int i = 0; i < len; i++) {
            result += Math.abs(moves[i]);
        }
        
		return result;
    }
}