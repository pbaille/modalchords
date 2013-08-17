require_relative "./musical_constants.rb"
require_relative "./Combinatorics.rb"
require_relative "./array_klass_adds.rb"

class Degree

  include MK
  GENERIC_NAMES= ["root", "second", "third", "fourth", "fifth", "sixt", "seventh"]
  NAME_DIST_MAP={"m2"=>1,"M2"=>2,"#2"=>3,"o3"=>2,"m3"=>3,"M3"=>4,"#3"=>5,"b4"=>4,"P4"=>5,"+4"=>6,"b5"=>6,"P5"=>7,"+5"=>8,"m6"=>8,"M6"=>9,"#6"=>10,"o7"=>9,"m7"=>10,"M7"=>11}
  DEFAULTS= {"root" => "C ", "second" => "M2", "third" => "M3", "fourth" => "P4", "fifth" => "P5", "sixt" => "M6", "seventh" => "M7"}
  ALTERATIONS={"root"    => {0 => "R"},
			   "second"  => {1 => "m2", 2 => "M2", 3 => "#2"},
			   "third"   => {2 => "o3", 3 => "m3", 4 => "M3", 5 => "#3"},
			   "fourth"  => {4 => "b4", 5 => "P4", 6 => "+4"},
			   "fifth"   => {6 => "b5", 7 => "P5", 8 => "+5"},
			   "sixt"    => {8 => "m6", 9 => "M6", 10 => "#6"},
			   "seventh" => {9 => "o7", 10 => "m7", 11 => "M7"}
			   }

  attr_reader :generic_name, :name, :dist

  def initialize *args
  	
  	test = args[0][1].to_i
  	
  	if test == 0 # args[0] is a generic_name
  	  @generic_name= args[0]
  	  if args.size == 2 # generic name + dist
  	  	@name= ALTERATIONS[args[0]][args[1]]
  	  else	
  	    @name = DEFAULTS[args[0]] 
  	  end
  	else # args[0] is a name
  	  @name = args[0]
  	  @generic_name= GENERIC_NAMES[args[0][1].to_i-1]
  	end  
  	@dist= NAME_DIST_MAP[@name]
  end

  def alt modifier
  	current_index=Degree.alt_map[generic_name].index(name)
  	if new_name=Degree.alt_map[generic_name][current_index + modifier]
  	  Degree.new new_name
  	else
  	  self
  	end    
  end	

  def self.alt_map
  	dam={}
  	NAME_DIST_MAP.each do |k,v|
  	  dam[GENERIC_NAMES[k[1].to_i-1]]||=[]
  	  dam[GENERIC_NAMES[k[1].to_i-1]]<< k
  	end	
  	dam
  end	
end

class AbstractNote
	include MK
	attr_reader :name, :mod12

	def initialize name_or_mod12
		if name_or_mod12.is_a? Fixnum
			@mod12= name_or_mod12
			@name=PITCHES.key(name_or_mod12)
		elsif name_or_mod12.is_a? String
			@name= name_or_mod12
			@mod12=PITCHES[name_or_mod12]
		elsif name_or_mod12.is_a? AbstractNote
			@name= name_or_mod12.name
			@mod12=name_or_mod12.mod12
		end	
	end	
end

class Note < AbstractNote

	attr_reader :pitch

	def initialize pitch
		@pitch= pitch
		super pitch%12
	end

	def transpose n
		@pitch+=n
		@mod12= pitch%12
		@name= PITCHES.key(mod12)
		self
	end	
end	

class Mode

	include MK	
			
	attr_reader :root,
				:degrees, 
				:abstract, 
				:concrete, 
				:prio, 
				:name, 
				:mother

	Moth=Struct.new :root,:name,:functs

	def initialize o={}

		o={name: o} if o.kind_of? String
		o={concrete: o} if o.kind_of? Array
		
		if o[:concrete]
			@root= AbstractNote.new(o[:concrete][0])
			@concrete= o[:concrete]
			abstract_calc
			name_calc
			mother_calc

		elsif o[:name]
			name_= o[:name].split.size == 2 ? o[:name] : "C #{o[:name]}"
			@name= name_
			@root= AbstractNote.new(name_.split[0])
			@abstract= Abstract_mode.new name_.split[1]
			concrete_calc
			mother_calc

		elsif o[:abstract] and o[:root]
			# p o[:abstract]
			# p o[:root]
			@root= AbstractNote.new(o[:root])
			@abstract= Abstract_mode.new o[:abstract]
			concrete_calc
			name_calc
			mother_calc

		elsif o[:mother] and o[:degree]
			@abstract=Abstract_mode.new o[:mother].split[1],o[:degree]
			@root=AbstractNote.new(PITCHES[o[:mother].split[0]]+abstract.moth_offset)
			concrete_calc
			mother_calc
			name_calc

		else p "have to provide abstract/root or concrete or name or mother/degree"
		end

		degrees_calc
		@prio= o[:prio] || prio_calc
	end

    #************************** CALCULUS ***********************************

	def root_calc
		@root=AbstractNote.new(concrete[0])
	end

	def abstract_calc
		@abstract= Abstract_mode.new(concrete.map {|x| (x-root.mod12+12)%12})
	end

	def concrete_calc
		@concrete= abstract.functs.map {|x| (x+root.mod12)%12}
	end

	def prio_calc
		@prio=abstract.prio
	end

	def name_calc
		if abstract.name
		  @name=  root.name + " " + abstract.name 
		else
		  @name= root.name+ " Unknown"
		end    
	end

	def mother_calc
		r=mother_root
		@mother=Moth.new(r, PITCHES.key(r)+" "+abstract.mother.name,abstract.mother.functs)
	end

	def degrees_calc
		@degrees=[]
		abstract.functs[1..-1].each_with_index {|x,i| @degrees << Degree.new(Degree::GENERIC_NAMES[i+1], x)}
	end	

	
    #************************** SETTERS ***********************************

	def root= arg
		@root = AbstractNote.new(arg)
		concrete_calc
		name_calc
		#prio_calc
		mother_calc
	end

	def abstract= arg
		if arg.is_a? Array
			@abstract=Abstract_mode.new arg
		else @abstract=arg
		end	
		concrete_calc
		name_calc
		prio_calc
		mother_calc
		degrees_calc
	end

	def concrete= arg
		@concrete=arg
		root_calc
		abstract_calc
		name_calc
		prio_calc
		mother_calc
		degrees_calc
	end

	def name= arg
		@name= arg
		@root= AbstractNote.new arg.split[0]
		@abstract= Abstract_mode.new arg.split[1]
		concrete_calc
		prio_calc
		mother_calc
		degrees_calc
	end

	def mother= moth_name
		if moth_name.split.size==1
			@abstract=Abstract_mode.new moth_name,degree
			@root=AbstractNote.new(mother.root+abstract.moth_offset)
		else 	
			@abstract=Abstract_mode.new moth_name.split[1],degree
			@root=AbstractNote.new(PITCHES[moth_name.split[0]]+abstract.moth_offset)
		end	
		concrete_calc
		@root= AbstractNote.new concrete[0]
		mother_calc
		name_calc
		degrees_calc
	end

		
    #*********************************************************************

	def intra_rel_move n
		self.concrete=concrete.rotate(n)
	end

	def intra_abs_move n
		self.concrete=concrete.rotate -(degree-1)+(n-1)
	end	

	def relative mode_name_str
		MOTHERS.each do |k,v| 
			if v[:degrees].include? mode_name_str
				@abstract=Abstract_mode.new k,(v[:degrees].index mode_name_str)+1 
				self.root=AbstractNote.new((mother.root+abstract.moth_offset)%12)
			end
		end	
		self.mother= Abstract_mode.new(mode_name_str).mother.name
	end

	def transpose n
		self.root= AbstractNote.new((root.mod12+n+12) %12)
	end

	def mother_struct_link
		all_moth_funct_struct(concrete.size).each do |x| 
			if i=concrete.is_transposition_of?(x)
				return [x,i] 
			end	
		end
	end	

    #************************ UTILS **************************************
	
	def mother_root
		(root.mod12-abstract.moth_offset)%12
	end	

	def degree
		abstract.degree
	end

	def prio 
		abstract.prio
	end

	def clone
		Mode.new name: @name, prio: @prio
	end

	def partials arg=(2..6), include_root=true #Fixnum or Range, root boolean

		f=abstract.functs.dup
		f.shift unless include_root
		# p "******************************"
		# p "concrete #{f}"

		if arg.is_a? Range

			results=Hash.new
			arg.each {|x| results[x]=f.combination(x).to_a.
				map {|xx| [xx,partial_prio_calc(xx)]}.sort_by(&:last).reverse}			
		else
			results=f.combination(arg).to_a.
			map {|xx| [xx,partial_prio_calc(xx)]}.sort_by(&:last).reverse
		end
		results
	end	

	@@prio_rating_ratio=Rational 1,2
	def partial_prio_calc partial
		rates=(0..6).to_a.map {|x| x*@@prio_rating_ratio}.zip([0]+prio.reverse)
		#rates=rates.zip([0]+prio.reverse)
		rates.select! {|x| partial.include? x[1]}.map!(&:first)
		rates.inject(:+)
	end	

	def display
		p "******************************"
		p "name #{name}"
		p abstract
        p "concrete #{concrete}"
        print "mother: "
        p mother
        print "root: "
        p root
        p degrees
	end

	#************ Class Methods ***************

	def self.all_modes_degrees_names #used in Search Model (used by Backbone) 
		result= {}
		MK.all_modes.each do |k,v|
			m=Mode.new abstract: k, root: 0
			result[k]= m.degrees.map{|x| [x.generic_name,x.name]}
			result[k]= result[k].transpose
			result[k]= Hash[result[k][0].zip(result[k][1])]
		end	
		result
	end	
end	

class ModeSelector < Mode

	attr_reader :status_hash

	STATUSES= [ "disabled", "enabled", "uniq", "optional" ]

	def initialize opt={}, status_h={}
		super opt
		@status_hash={}
		Degree::GENERIC_NAMES.each {|e| @status_hash[e]= "enabled"}
		status_h.each {|k,v| @status_hash[k]= v} 
	end

	def self.new_from_degree_status_hash dsh
		root_= PITCHES[dsh["root"].split[0]]
		concrete_= [0]
		status_tab_={}
		dsh.each do |k,v|
		  concrete_ << Degree::NAME_DIST_MAP[v.split[0]] if k != "root"
		  status_tab_[k]= v.split[1]
		end  
		p concrete_
		ModeSelector.new(concrete_.map {|x| (x+root_)%12},status_tab_)
	end	

	def set_status *args

		if args[0].is_a? Hash

			args[0].each do |k,v|
			  if @status_hash.has_key? k
			    @status_hash[k]= v
			  else
			    @status_hash[Degree::GENERIC_NAMES[k[1].to_i-1]]= v    
			  end
			end 
			 
		elsif args[0].is_a? String
			status_hash.each {|k,v| @status_hash[k]= args[0]}
		end	
	end	

	def degree_status_hash
		result_hash= {"root" => root.name+" "+@status_hash["root"]}
		@status_hash.each {|k,v| result_hash[k]= degrees.select{|d| d.generic_name == k}[0].name + " " + v if k != "root"}
		result_hash
	end

	def to_MSS
  	  ModalSearchStruct.new(ultra_concrete, occ_array, root.mod12)
    end

    def display
		super
		print "status_hash: "
		p status_hash
		p "******************************"
	end

    private
    def ultra_concrete
		uc=[]
		degree_status_hash.each do |k,v|
		  if k == "root"
		  	uc << 0 if v.split[1] != "disabled" 
		  else	
		    uc<<Degree::NAME_DIST_MAP[v.split[0]] if v.split[1] != "disabled" 
		  end  
		end 
		uc.map {|x| (x+root.mod12)%12}
	end

	def occ_array
		oa=[]
		status_hash.each do |k,v|
		  oa << v if v != "disabled"
		end	
		oa.map do |x|
		  case x
  		  when "enabled" then 2
  		  when "uniq" then 1
  		  when "optional" then -1
  		  end
		end	
	end	  	
end	

class GuitarModel

	TUNING= [40,45,50,55,59,64]
	FRETBOARD_LENGTH=24

	attr_accessor :tuning, :fretboard_length
	attr_reader :notes	

	def initialize o={}
		@tuning= o[:tuning] || TUNING
		@fretboard_length = o[:fretboard_length] || FRETBOARD_LENGTH
		@notes= notes	
	end	

	def notes
		@tuning.map {|s| (s..s+@fretboard_length).to_a }
	end

	def tune arr
		@tuning=arr
		@notes=notes
	end

	def nb_strings
		@tuning.size
	end

	#some change have been done, untested
	def to_tab arr #arr= array of pitches
		arr.map.with_index {|x,i| x-@tuning[i] if x}
	end	
end	

class ModalSearchStruct

  attr_reader :functs, :occs, :root

	def initialize funct_arr, occ_arr=nil, root=nil
		@root= root ? root : funct_arr[0]
		@functs=funct_arr
		occ_arr ? @occs = occ_arr : @occs = Array.new(funct_arr.size,2) #default occ_tab to 2 occ per funct
		sort_all
	end	

	# Array#transpose method applied to self
	def transpose 
		[@functs,@occs].transpose
	end

	private
	def sort_all
		index_sort=@functs.map.with_index.sort_by(&:first).map(&:last)
		@functs=@functs.sort
		@occs=@occs.values_at(*index_sort)
	end	
end

class FretboardSlice < GuitarModel

	attr_reader :low_fret, :high_fret, :width, :available_notes

	def initialize low=0, high=12, tuning=[40,45,50,55,59,64]
		super(:tuning => tuning)
		@low_fret= low
		@high_fret = high
		@width = @high_fret - @low_fret + 1 
		@available_notes = notes_calc
	end

	def notes_calc	
		@notes.map {|x| ([x[0]]+x[@low_fret..@high_fret]).uniq}
	end

	def tonal_filter functs
		@available_notes.map {|x| x.map {|xx| functs.include?(xx%12) ? xx : nil }}
	end

	def move_to fret
		@low_fret= fret
		@high_fret= @low_fret + @width - 1
		notes_calc
		self	
	end

	#return an array of all fretboard_slice objects of a certain width contained in self 
	def positions width_
		array=[]
		(0..@width-width_).each do |x|
			low=@low_fret+x
			high=low+width_-1
			array<< FretboardSlice.new(low,high,@tuning)
		end	
		array
	end	
end	

class JSONable
    def to_json
        hash = {}
        self.instance_variables.each do |var|
            hash[var] = self.instance_variable_get var
        end
        hash.to_json
    end
    def from_json! string
        JSON.load(string).each do |var, val|
            self.instance_variable_set var, val
        end
    end
end	

class ChordMF < JSONable # MF => multi format

	attr_reader :root, 
				:pitches,
				:tab,
				:display_format, 
				:tab_index

	def initialize pitches_arr, opt={}
		@pitches=pitches_arr

		if opt[:fretboard_slice]
			@tab=opt[:fretboard_slice].to_tab(pitches_arr) 
		elsif opt[:tab]
		    @tab= opt[:tab]
		else
		    "error init wrong args"    	
		end

		opt[:root] ? @root = opt[:root] : @root = pitches_arr.compact.sort[0]%12      

		@tab_index=@tab.select{|x| x!=0}.compact.sort[0]
		df_calc
	end

	def df_calc
        @display_format=tab.map.with_index do |x,i| 
          if x and x>0
            i+(x-@tab_index+1)*tab.size if x>0
          elsif x==0  
            i
          end    
        end
        @display_format.compact!
	end

	def functs
		pitches.to_functs
	end

	def inter_tab
		pitches.compact.sort.inter_tab			
	end

	def voices
		pitches.size
	end

	def instrument_tuning
		if pitches.any? {|x| x==nil}
			"sorry cannot find tunning based on un complete chord"
		else	
			arr=[pitches, tab].transpose
			arr.map {|x| x[0]- x[1] if x[0]}
		end	
	end	

	def to_hash
		hash = {}
		self.instance_variables.each {|var| hash[var.to_s.delete("@")] = self.instance_variable_get(var) }
		hash	
	end

	def self.from_hash h
        self.new h[:pitches], tab: h[:tab]
    end
end

class ChordFilter

	attr_reader :type, :proc

	def initialize type, *args
		@type = type
		@proc = send(type,*args)
	end

	#all filters return true if chord has to be filtered
	def max_step max
		Proc.new {|c| c.inter_tab[1..-1].any? {|x| x > max}}
	end

	def bass_max_step max
		Proc.new {|c| c.inter_tab[0] > max }
	end	

	def interval_range int, min, max=127
		Proc.new do |c|
		  work_arr=[c.inter_tab, c.pitches.compact.sort[0..-2]].transpose
		  work_arr.any? {|x| x[0]==int && ( x[1] < min or x[1] > max)}
		end 
	end

	def inversions bool
		p "bool_inversion = #{bool}"
		if bool
          Proc.new {|c| c.root == c.pitches.compact.sort[0]%12 }
		else	
          Proc.new {|c| c.root != c.pitches.compact.sort[0]%12 }
        end  
	end

	#if bool == true return true for all chord that doesn't have an open string
	#if bool == false return true for all chords that has one or more
	def open_strings bool
		if bool
			Proc.new {|c| not c.tab.any? {|x| x == 0}}
		else
			Proc.new {|c| c.tab.any? {|x| x == 0}}
		end	
	end	

	def twin_pitches bool
		if bool
			Proc.new {|c| c.pitches.compact.sort.uniq == c.pitches.compact.sort }
		else
			Proc.new {|c| c.pitches.compact.sort.uniq != c.pitches.compact.sort }
		end	
		
	end

	def b9 bool
		if bool
			Proc.new {|c| if c.pitches.compact.sort.has_b9? then false else true end}
		else
			Proc.new {|c| if c.pitches.compact.sort.has_b9? then true else false end}
		end	
	end
end	

class ChordSearch
	include Combinatorics
	include MK

	attr_reader :fretboard_slice, 
				:mode_selector,
		        :mss_arr, 
			    :fingerings_options, 
			    :filters, 
		        :chords

	def initialize fs, mode_sel, fo={}, filt=[]

		@mode_selector = mode_sel	
		@mss_arr= [@mode_selector.to_MSS]
		@fretboard_slice= fs
		@fingerings_options=fo
		@filters= [*filt]

		@chords=[]

		split_impossible_structs
		optional_struct_split

	end

	def reset
		@chords=[]
	end

	def search
		@mss_arr.each do |e|
			global_search e
		end

		apply_filters unless @filters == {}
	end	

	def global_search modal_search_struct
		max_width= fingerings_options[:max_width] || 4

		positions=@fretboard_slice.positions max_width

		positions.each do |p|
			
			#convert results in tab format
			regular_chords=local_search(modal_search_struct,p)
			mf_chords=regular_chords.map do |e|
				ChordMF.new(e,{fretboard_slice: @fretboard_slice, root: modal_search_struct.root})
			end

			#inserrt each in @chords
			mf_chords.each {|e| @chords<< e}
			
		end
	end

	def local_search modal_search_struct, position

		local_results=[]

		#replace unneeded notes of position by nil
		search_array= position.tonal_filter modal_search_struct.functs
		#p "search_array => #{search_array}"

		#find all first case possibilities
		  #construct first case possibilities array [[pitch,string],[pitch,string],...]
		  first_case=search_array.each_with_index.map {|x,i| if x[1] then [x[1],i] else nil end}.compact
		  #find each combinations
		  first_case_combinations=[]
		  (1..first_case.size).each {|x| first_case_combinations<<first_case.combination(x).to_a}
		  first_case_combinations.flatten!(1) 

		#for each reconstruct search_array
		#delete 1 indexes (contains index finger notes)  (conditional is for the case that no pitch available on a string)
		search_array.map! {|e| e.delete_at(1); if e.compact.empty? then [nil] else e.compact end}

		first_case_combinations.each do |x|
			search_array_cp=search_array.dup
			x.each do |xe|
				search_array_cp[xe[1]]=[xe[0]]
			end	
			#then send it to comb_zip and stock it in local_results
			comb_zip(search_array_cp).each {|e| local_results<<e}

		end

		# p "first => #{local_results.map{|x| x.to_functs }}"
		# p "-----------"

		#remove uncomplete partials
		local_results.delete_if {|r| r.to_functs.compact.uniq.sort != modal_search_struct.functs.sort}

		# p "after delete => #{local_results.map{|x| x.to_functs }}"
		# p "-----------"

		# p "after delete (tab) => #{local_results.map{|x| position.to_tab x }}"
		# p "-----------"

		#add "removed functs duplicate" combinations
		local_results.each do |c|
			#p "each-loop #{ChordMF.new(c, position).inspect}"
			cf=c.to_functs
			#find and locate duplicates [[item,[indexes]],...]
			duplicates=cf.map{ |e| [e,cf.each_index.select{|i| cf[i] == e}] }.uniq
			duplicates.delete_if {|x| x[1].size == 1 or x[0] == nil}

			#remove them one by one from c and append it to local_results
			duplicates.each do |d|
				d[1].each do |di|
					cd=c.dup
					cd[di]=nil
					# condition only check if first case of fb_loc is here
					if (position.to_tab(cd)).delete_if{|x| x==0}.compact.min==position.low_fret
						local_results<<cd 
						#p "appended => #{ChordMF.new(cd, position).inspect}"
					end	
				end	
			end	
		end

		#occ_tab filter
		local_results.delete_if do |r|
		  #p "occ-loop #{r.to_functs}" if r.to_functs == [nil, 11, 4, nil, 3, 8 ]
		  r_occ=occ_tab(r.to_functs.compact).transpose[1]
		  occ_diff=r_occ.map.with_index {|x,i| modal_search_struct.occs[i]-x}
		  occ_diff.any? {|x| x<0}
		  #p res if r.to_functs == [nil, 11, 4, nil, 3, 8 ]
		end 

		#p "include test1 => #{local_results.include? [nil, 47, 52, nil, 63, 68]}"

		#b9 filter
		#local_results.delete_if {|r| r.compact.sort.has_b9?}

		#p "include test2 => #{local_results.include? [nil, 47, 52, nil, 63, 68]}"

		#TODO remove impossible fingerings

		# 'add "removed functs duplicate" combinations' can produce duplicates, just remove them
		local_results.uniq
	end

	# if funct.size > nb_Strings split mss into several mss of nb_strings size
	def split_impossible_structs

		results=[]

		if (defined?(settings)).nil?
          n_strings=6
        else
          n_strings=settings.strings_nb
        end        

		@mss_arr.each do |mss|
			if mss.functs.size > n_strings #@fingerings_options[:max_width]
				mss.transpose.combination(@fretboard_slice.nb_strings).each {|c| results<<ModalSearchStruct.new(c.transpose[0],c.transpose[1],mss.root)}
			else
				results<<mss
			end
		end
		@mss_arr=results		
	end

	def optional_struct_split 

		results=[]

		@mss_arr.each do |mss|
			mss_root= mss.root
			if mss.occs.any? {|x| x<0 }

				mss=mss.transpose

				opt_part= mss.select{|x| x[1] < 0}
				reg_part= mss.select{|x| x[1] > 0}
				
				(1..opt_part.size).to_a.each do |n|

					opt_part.combination(n).each do |c|

						reg_part_cp= reg_part.dup
						join=(reg_part_cp+c).transpose
					  results<< ModalSearchStruct.new(join[0],join[1],mss_root)

					end  
				end	

				#add chord without any optional elements
				reg_part_only=reg_part.transpose
				results<<ModalSearchStruct.new(reg_part_only[0],reg_part_only[1],mss_root)

				#make occurence of optional elems positive
				results.each_with_index {|r,i| results[i].occs.map!{|x| if x < 0 then x* -1 else x end}}
			else
				results << mss
			end
		end	
		@mss_arr=results
	end

	def apply_filters
		@filters.each do |f|
			@chords.delete_if &(f.proc)
		end	
	end	
end

##### MODE DEGREE NOTE ############################

#m= Mode.new root: 3, abstract: "Lyd"
#p m

#p Mode.all_modes_degrees_names

# d= Degree.new "m2"
# p d

# d= Degree.new "third"
# p d

# d= Degree.new("fourth").alt(-1)
# p d

# d= Degree.new "third", 3
# p d

# n = Note.new(90).transpose(12)
# p n

# an= AbstractNote.new "C#"
# p an

# an= AbstractNote.new 3
# p an

### FILTERS ##########################################

# cmf= ChordMF.new([nil,46,47,56,61,66],{ fretboard_slice: FretboardSlice.new(), root: 11})
# p cmf
# p cmf.instrument_tuning

# cf=ChordFilter.new :max_step, 4
# p cf.proc.call cmf

# cf=ChordFilter.new :interval_range, 5, 46
# p cf.proc.call cmf

# cf=ChordFilter.new :inversions, false
# p cf.proc.call cmf

# cf=ChordFilter.new :open_strings, false
# p cf.proc.call cmf

# cf=ChordFilter.new :twin_pitches, true
# p cf.proc.call cmf

##*********** MODE SELECTOR ************************
# ms= ModeSelector.new "Eb Lyd+",{"root" => "disabled"}
# ms.display
# ms.set_status({"m2" => "uniq", "+5" => "disabled"})
# ms.display
# p ms.degree_status_hash

# p ms.to_MSS

# ms = ModeSelector.new_from_degree_status_hash({"root"=>"Eb disabled", 
# 											   "second"=>"M2 enabled", 
# 											   "third"=>"M3 enabled", 
# 											   "fourth"=>"+4 disabled", 
# 											   "fifth"=>"+5 enabled", 
# 											   "sixt"=>"#6 enabled", 
# 											   "seventh"=>"M7 enabled"})

# ms.display
# p ms.partials
# ##******************* CS ***************************
# cs= ChordSearch.new(FretboardSlice.new(0,8),
# 	                       ms,
# 	                       {:max_width=>5},
# 	                       ChordFilter.new(:root_bassed))
# cs.search

# cs.chords.each do |c|
# 	p c
# end	
#***************** MODE ***************************

# Mode.new([0,2,3,6,7,9,10])
# bob= Mode.new "C# Phry"
# bob.display
# p bob.partials (3..5)
# # # bab= Mode.new abstract: [0,2,3,5,7,9,11], root: 2
# # # bab.display
# bob.relative("Alt")
# bob.display

# bob.mother= "Lyd+9"
# bob.display

# #p bob.mother_struct_link
# bob=Mode.new "C Lyd"
# p bob.partials

# bob.partial_prio_calc [5,8,11]
# bob.abstract=Abstract_mode.new "Mixb6"
# bob.display

# p "name="
# bob.name="D Lyd+"
# bob.display

# p"root="
# bob.root=5
# bob.display

# p"concrete="
# bob.concrete=[2,4,6,8,9,11,0]
# bob.display

# p"rel3"
# bob.intra_rel_move 3
# bob.display

# p"abs3"
# bob.intra_abs_move 1
# bob.display

# bob.transpose 3
# bob.display

# bob= Mode.new mother: "D Lyd", degree: 3
# bob.display


# bob= Mode.new abstract: [0,1,3,4,6,8,10], root: 7
# bob.display

