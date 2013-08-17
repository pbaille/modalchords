module Combinatorics
	
	#***************** GENERAL_PURPOSE ******************************

	def statusCombination(a)
		#a=int[] (maxVal of each slot)
		# Caution!!! values from 0! 1=> 2 status (0,1)

		result,temp=[],[]
		
		a.each do |x|
			result.clear
			if temp.empty?
			   (0..x).each {|y| result<<y}
		    else
		       (0..x).each{|z| temp.map {|i| result<<[i]+[z]}}
		    end
		    temp=Array.new(result)
		end
		result.map! {|x| x.flatten} 
	end	
	
	def comb_zip(a)

		results=[]
		status_tab=a.map {|x| x.size-1}
		#p status_tab
	
		statusCombination(status_tab).each do |x|
			results<< x.each_with_index.map {|y,i| a[i][y]}
		end	
		results
	end	
	
	def occ_tab (a)
		_a=a.sort
		_a.chunk {|x| x}.map {|x| [x[0],x[1].size]}
	end

	#***********
	class Domain_partition
    
	    attr_reader :results,
	                :domain,
	                :sum,
	                :size
	
	    def initialize(_dom, _size, _sum)
	        _dom.is_a?(Array) ? @domain=_dom.sort : @domain= _dom.to_a
	        @results, @sum, @size = [], _sum, _size
	        arr = [0]*size  # create an array of size n, filled with zeroes
	        sumRecursive(size, 0, arr)
	    end
	    
	    def sumRecursive(n, sumSoFar, arr)
	        
	        if n == 1
	            #Make sure it's in ascending order (or only level)
	            if sum - sumSoFar >= arr[-2] and @domain.include?(sum - sumSoFar)
	                final_arr=Array.new(arr)
	                final_arr[(-1)] = sum - sumSoFar #put it in the n_th last index of arr
	                @results<<final_arr
	            end
	                
	        elsif n > 1
	
	            #********* dom_selector ********
	            #is an previously rejected domain element can be authorized?...
	
	            n != size ? start = arr[(-1*n)-1] : start = domain[0]
	            dom_bounds=(start*(n-1)..domain.last*(n-1))
	
	            restricted_dom=domain.select do |x|
	
	                if x < start 
	                    false; next
	                end
	
	                if size-n > 0
	                    if dom_bounds.cover? sum-(arr.first(size-n).inject(:+)+x) then true
	                    else false end  
	                else 
	                    dom_bounds.cover?(sum+x) ? true : false
	                end
	            end # ***************************
	            
	            for i in restricted_dom
	                _arr=Array.new(arr)
	                _arr[(-1*n)] = i 
	                sumRecursive(n-1, sumSoFar + i, _arr)
	            end
	        end
	    end
	end 
	#***********

	#********************** MUSICAL_PURPOSE**********************************

	def all_moth_funct_struct *args #range,fixnum or nothing (default 3..8)

		if args[0].is_a? Range
			range=args[0]
		elsif args.size==2
			range=(args[0]..args[1])
		elsif args[0].is_a? Fixnum
			range=(args[0]..args[0])
		else
			range=(3..8)			
		end

		results=Hash.new
		range.each do |len|
			st=[]
			dp=Domain_partition.new (1..11),len,12
			dp.results.each {|x| x.unique_permutation_no_rot.each {|u| st<<u}}
			results[len]= st.map {|x| x.first(x.size-1).intervals_to_functs}
		end	
		#if args is a range returns a hash else return an array 
		results.keys.size==1 ? results[args[0]] : results
	end

	def all_struct_owners_hash *args #range,fixnum or nothing (default 3..8)

		if args[0].is_a? Range
			range=args[0]
		elsif args.size==2
			range=(args[0]..args[1])
		elsif args[0].is_a? Fixnum
			range=(args[0]..args[0])
		else
			range=(3..8)			
		end

		modes=MK.all_modes
		structs_hash=Hash.new

		range.each do |n|
			(0..11).to_a.combination(n).to_a.map do |x|
				b=[x,[]]
				modes.each {|k,y| b[1]<<k if x.all? {|z| y.include?(z)}}
				b[1].empty? ? nil : b
			end.compact.each {|z| structs_hash[z[0]]=z[1]}
		end
		structs_hash
	end	

	def all_lyd_mothers
		alt_name,results=["#9","#3","#5","#6"],Hash.new
		statusCombination([1,1,1,1]).each do |x|
			name="Lyd" 
			x.each_with_index {|y,i| name=name+alt_name[i] if y==1}
			results[name]=[0,2+x[0],4+x[1],6,7+x[2],9+x[3],11]
		end
		results
	end

		
	
end

# include Combinatorics

#examples
# a=statusCombination [2,2,2,2,2,2,2]
# a.map! {|x| x.inject(:+)<3 ? nil : x}.compact!
# a.sort_by! {|x| x.inject(:+)}
# p a
# p a.size
#p comb_zip([[nil], [nil], [nil], [nil]])
#p occ_tab([1,2,3,1,2,3,4,6,2,1,5,3])

# aa=Domain_partition.new (-6..6),10,0 
# p aa
# p aa.results.size



