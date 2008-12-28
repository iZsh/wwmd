module WWMD
	# yay for experiments in re-inventing the wheel
	class URLParse
		HANDLERS = [:https,:http,:ftp,:file]
		attr_reader :proto,:location,:path,:script,:rpath

		def initialize()
			# nothing to see here, move along
		end

		def parse(base,actual)
			@proto = @location = @path = @script = @rpath = nil
			@base = base
			@actual = actual
			if self.has_proto?
				@base = @actual
				@actual = ""
			end
			@base += "/" if (!@base.has_ext? || @base.split("/").size == 3)
			@rpath = make_me_path.join("/")
			@path = "/" + @rpath
			if @rpath.has_ext? then
				@path = "/" + @rpath.dirname
				@script = @rpath.basename
			end
			return "#{@proto}://#{@location}/#{rpath}"
#			return "#{@proto}://#{@location}#{@path}#{script}"
		end

		def make_me_path
			@proto,tpath = @base.split(":",2)
			if @actual.empty? then
				a_path = tpath.split("/").reject { |x| x.empty? }
			else
				a_path = tpath.dirname.split("/").reject { |x| x.empty? }
			end
			@location = a_path.shift
			a_path = [] if !(@actual =~ (/^\//)).nil?
			b_path = (a_path + @actual.split("/").reject { |x| x.empty? }).flatten
			c_path = []
			b_path.each do |x|
				(c_path.pop;next) if x == ".."
				next if x == "."
				c_path << x
			end
			return c_path
		end

		def has_proto?
			return true if HANDLERS.include?(@actual.split(":").first.downcase.to_sym)
		end

	end
end

class String
	def has_ext? #:nodoc:
		return false if self.basename.split(".",2)[1].empty?
		return true
	end
end
