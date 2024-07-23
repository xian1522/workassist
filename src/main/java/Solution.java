import org.omg.PortableInterceptor.INACTIVE;

import java.util.*;

public class Solution {
    /**
     * 查找共用字符
     * @param words
     * @return
     */
    public List<String> commonChars(String[] words) {
        List<String> res = new ArrayList<>();
        int[] main = new int[26];
        for(int i=0; i<words[0].length(); i++) {
            char c = words[0].charAt(i);
            main[c - 'a']++;
        }
        for (String word : words) {
            int temp[] = new int[26];
            for(int i=0; i<word.length(); i++) {
                char c = word.charAt(i);
                temp[c - 'a']++;
            }

            for(int i = 0; i<26; i++) {
                main[i] = Math.min(main[i], temp[i]);
            }
        }
        for(int i = 0; i<26; i++) {
            while (main[i] != 0) {
                res.add(String.valueOf((char)('a' + i)));
                main[i]--;
            }
        }
        return res;
    }
    //nums1 = [4,9,5], nums2 = [9,4,9,8,4]
    public int[] intersection(int[] nums1, int[] nums2) {
        Map<Integer, Integer> interMap = new HashMap<>();
        Map<Integer, Integer> res = new HashMap<>();

        for(int i=0; i<nums1.length; i++) {
            Integer count = interMap.getOrDefault(nums1[i], 0);
            interMap.put(nums1[i], count+1);
        }
        for (int i=0; i<nums2.length; i++) {
            Integer count = interMap.getOrDefault(nums2[i], 0);
            if(count > 0) {
                res.put(nums2[i],1);
            }
        }

        int[] result = new int[res.size()];
        int i=0;
        for (Map.Entry entry : res.entrySet()) {
            result[i] = (Integer)entry.getKey();
            i++;
        }
        return result;
    }

    public int getSqureSum(int i){
        int sum = 0;
        while (i > 0) {
            int i1 = i % 10;
            sum += i1 * i1;
            i = i / 10;
        }
        return sum;
    }

    public boolean isHappy(int n) {
        int slow = n;
        int fast = n;
        do {
            slow = getSqureSum(slow);
            fast = getSqureSum(fast);
            fast = getSqureSum(fast);
        }while (slow != fast);

        return slow == 1;
    }

    public boolean canConstruct(String ransomNote, String magazine) {
        int[] notes = new int[26];
        int[] mgz = new int[26];
        for(int i =0; i< ransomNote.length(); i++) {
            char c = ransomNote.charAt(i);
            notes[c - 'a']++;
        }
        for(int i =0; i< magazine.length(); i++) {
            char c = magazine.charAt(i);
            mgz[c - 'a']++;
        }
        for(int i=0; i<26; i++) {
            if(notes[i] != 0 && notes[i] <= mgz[i]) {
                return false;
            }
        }
        return true;
    }

    public int fourSumCount(int[] nums1, int[] nums2, int[] nums3, int[] nums4) {
        int rescount = 0;
        Map<Integer, Integer> res = new HashMap<>();
        for(int i : nums1) {
            for(int j : nums2) {
                Integer count = res.getOrDefault(i + j, 0);
                res.put(i + j, count + 1);
            }
        }
        for(int i : nums3) {
            for(int j : nums4) {
                if(res.containsKey(-i - j)){

                    rescount += res.get(-i -j);
                }
            }
        }
        return rescount;
    }

    //nums = [-4,-1,-1,0,1,2]
    public List<List<Integer>> threeSum(int[] nums) {
        List<List<Integer>> res = new ArrayList<>();
        Arrays.sort(nums);

        for(int k = 0; k < nums.length - 2; k++) {
            if(nums[k] > 0) break;
            if(k > 0 && nums[k] == nums[k - 1]) continue;
            int i = k + 1, j = nums.length - 1;
            while (i < j) {
                int sum = nums[k] + nums[i] + nums[j];
                if(sum < 0) {
                    while (i < j && nums[i] == nums[++i]);
                }else if(sum > 0) {
                    while (i < j && nums[j] == nums[--j]);
                }else {
                    List<Integer> list = Arrays.asList(nums[k], nums[i], nums[j]);
                    res.add(list);
                    while (i < j && nums[i] == nums[++i]);
                    while (i < j && nums[j] == nums[--j]);
                }
            }
        }
        return res;
    }

    public static void main(String[] args) {
        int[] nums = {-1,0,1,2,-1,-4};
        System.out.println(new Solution().threeSum(nums));
    }
}
