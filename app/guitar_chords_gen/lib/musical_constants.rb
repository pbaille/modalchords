module MK #musical_constants
  
  # :)
	MIDI_NOTES=Hash[*(-5..5).to_a.map do |i|
		["C ","Db ","D ","Eb ","E ","F ","Gb ","G ","Ab ","A ","Bb ","B "].map.with_index do |n , mi|
			[n+i.to_s,(i+5)*12+mi]
		end
	end.flatten]

	PITCHES= { "C" => 0,
			   #"C#" => 1,
			   "Db" => 1,
			   "D" => 2,
			   #"D#" => 3,
			   "Eb" => 3,
			   "E" => 4,
			   #"Fb" => 4,
			   #"E#" => 5,
			   "F" => 5,
			   "F#" => 6,
			   "Gb" => 6,
			   "G" => 7,
			   #"G#" => 8,
			   "Ab" => 8,
			   "A" => 9,
			   #"A#" => 10,
			   "Bb" => 10,
			   "B" => 11
			   #"Cb" => 11,
			   #"B#" => 0
			   }

	DURATIONS= { w:  Rational(1),
				 h:  Rational(1,2),
				 q:  Rational(1,4),
				 e:  Rational(1,8),
				 s:  Rational(1,16),
				 t:  Rational(1,32),
				}

	MOTHERS={ "Lyd"  => {functs: [0,2,4,6,7,9,11],
						degrees:["Lyd","Mix", "Eol", "Loc", "Ion", "Dor", "Phry"],
						modes_prio:[[6,11,4,9,2,7],
						  		    [10,5,4,9,2,7],
						  		    [8,2,7,3,10,5],
						  		    [6,1,10,8,3,5],
						  		    [11,5,4,9,2,7],
						  		    [9,3,10,2,7,5],
						  		    [1,7,5,10,3,8]]
						  		    },

			  "Lyd+" => {functs: [0,2,4,6,8,9,11],
						degrees: ["Lyd+","Lydb7", "Mixb6", "Loc2", "Alt", "Melm", "Phry6"],
						modes_prio:[[8,11,4,6,9,2],
						  		    [6,10,4,9,2,7],
						  		    [8,4,2,7,5,10],
						  		    [6,2,3,10,5,8],
						  		    [4,10,8,3,6,1],
						  		    [11,3,9,2,7,5],
						  		    [9,1,5,10,3,7]]
						  		    },

			  "Lyd+9"=> {functs: [0,3,4,6,7,9,11],
						degrees: ["Lyd+9","AltDim", "Harmm", "Loc6", "Ion+", "Dor#4", "PhryM"],
						modes_prio:[[6,3,11,4,9,2],
									[4,9,1,6,8,3 ],
									[8,11,2,3,7,5],
									[6,9,1,10,3,5],
									[5,8,11,3,2,9],
									[9,6,3,2,10,7],
									[1,4,7,10,8,5]]
						  		    }
			}

	MOTHER_STEPS= { "Lyd"  =>[2,2,2,1,2,2,1],
					"Lyd+" =>[2,2,2,2,1,2,1],
					"Lyd+9"=>[3,1,2,1,2,2,1]
				    }

	MODAL_MOVES={"SD" => 5,
				 "SD-" => 8,
				 "SD+" => 2,
				 "SDalt" => 11,
				 "T" => 0,
			     "T-" => 3,
				 "T+" => 9,
				 "Talt" => 6
				}

	DEGREES_NAMES=[{0 => "R"},
				   {1 => "m2", 2 => "M2", 3 => "#2"},
				   {2 => "o3", 3 => "m3", 4 => "M3", 5 => "#3"},
				   {4 => "b4", 5 => "P4", 6 => "+4"},
				   {6 => "b5", 7 => "P5", 8 => "+5"},
				   {8 => "m6", 9 => "M6", 10 => "+6"},
				   {9 => "o7", 10 => "m7", 11 => "M7"}
				  ]

	ABSTRACT_DEGREES=["root", "second", "third", "fourth", "fifth", "sixt", "seventh"]

	def MK.all_modes
		modes=Hash.new
		MOTHERS.each do |k,v| 
			modes.merge!(MK.childs(k))
		end
		modes
	end

	def MK.childs m
		if MOTHERS.keys.include? m
    		modes=Hash[MOTHERS[m][:degrees].zip(MOTHERS[m][:functs].tonicized_rotations)]
    	else nil 
    	end
    end

    def MK.regular_mothers
    	reg_moths={}
    	MOTHERS.each do |k,v| 
		    case k
		    when "Lyd"
		    	reg_moths["Major"]={:funct => v[:functs].rotate(4).tonicize,
		    							  :degrees => v[:degrees].rotate(4),
		    							  :modes_prio => v[:modes_prio].rotate(4)}
		    when "Lyd+"
		    	reg_moths["Melodic Minor"]={:funct => v[:functs].rotate(5).tonicize,
		    							  :degrees => v[:degrees].rotate(5),
		    							  :modes_prio => v[:modes_prio].rotate(5)}
		    when "Lyd+9"
		    	reg_moths["Harmonic Minor"]={:funct => v[:functs].rotate(2).tonicize,
		    							  :degrees => v[:degrees].rotate(2),
		    							  :modes_prio => v[:modes_prio].rotate(2)}
		    end							  							  							  
		end
		reg_moths	
    end
    	
end

class Abstract_mode

	include MK

	attr_accessor :name,
				  :functs, 
				  :prio, 
				  :degree, 
				  :mother

	Abs_moth=Struct.new(:name,:functs)

	

	def initialize *args #funct_tab(Array) mode_name(String) or mother_name(String),degree(Fixnum)
		if args.size==1
			if args[0].is_a? String then new_by_name args[0]
			else new_by_functs args[0] end
		else new_by_mother args[0],args[1] end
	end	

	def new_by_name s

		if MOTHERS.keys.include? s
			m=MOTHERS[s]
			@name= s
			@functs= m[:functs]
		    @prio= m[:modes_prio][0]
		    @degree= 1
		    @mother= Abs_moth.new s,functs

		else
			MOTHERS.each do |k,v|
				if v[:degrees].include? s
					@name=s
					@degree=v[:degrees].index(s)+1
					@functs=childs(k)[degree-1]
					@mother=Abs_moth.new(k,v[:functs])
					@prio=v[:modes_prio][v[:degrees].index(s)] 
				end	
			end		
		end
	end

	def new_by_mother m, d=1
		@name= MOTHERS[m][:degrees][d-1]
		@functs= MOTHERS[m][:functs].rotate(d-1).map {|x| (x-MOTHERS[m][:functs][d-1]+12)%12}
		@prio= MOTHERS[m][:modes_prio][d-1]
		@mother= Abs_moth.new(m,MOTHERS[m][:functs])
		@degree= d
    end

    def new_by_functs a	
    	MK.all_modes.each do |k,v|
    		if a.all? {|w| v.include? w} 
    			new_by_name k
    			break
    		end	
    	end
    	
    	#if unknown mode
    	unless @name
    	   @name= "unknown"
		   @functs= a
		   @prio= a[1..-1]
		   @mother= Abs_moth.new("unknown",a)
		   @degree= 1	
		end

	end	

    def childs m
    	modes=[MOTHERS[m][:functs]]
    	(1..modes[0].size-1).each {|x| modes<< modes[0].rotate(x)}
    	modes.each.map {|x| x.map{|z| (z-x[0]+12)%12}}
    end

    def moth_offset
    	if mother
    		# p degree
    		# p mother.functs
    		mother.functs[degree-1] 
    	else 0
    	end	
    end

    def is_mother?
    	name==mother.name and functs==mother.functs
    end

    def degrees_names
    	hash = {}
    	@functs.each_with_index do |x, i|
    		hash[x] = DEGREES_NAMES[i][x]
    	end	
    	hash
    end	

    # def mother.name
    # 	if mother then mother.name
    # 	else name end	
    # end	

end

# require_relative "./Combinatorics"
# require_relative "./array_klass_adds"

# p MK.all_modes

# include MK

# p MIDI_NOTES
#include Known_modes

# a=Abstract_mode.new "Mix"
# p a.is_mother?

# a=Abstract_mode.new "Loc2"
# p a.degrees_names

#b=Abstract_mode.new "Mix"
#p b
# a=Abstract_mode.new_by_mother "Lyd", 4
# p a

# #a.mother.name
# # Known_modes.by_mother "Lyd",4
# #Known_modes.childs "Lyd"
# p Abstract_mode.new [0,2,3,6,7,9,10]




