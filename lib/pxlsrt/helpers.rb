module Pxlsrt
	##
	# Methods not having to do with image or color manipulation.
	class Helpers
		##
		# Determines if a value has content.
		def self.contented(c)
			return c != nil
		end
		##
		# Used to output a red string to the terminal.
		def self.red(what)
			return "\e[31m#{what}\e[0m"
		end
		##
		# Used to output a cyan string to the terminal.
		def self.cyan(what)
			return "\e[36m#{what}\e[0m"
		end
		##
		# Used to output a yellow string to the terminal.
		def self.yellow(what)
			return "\e[33m#{what}\e[0m"
		end
		##
		# Used to output a green string to the terminal.
		def self.green(what)
			return "\e[32m#{what}\e[0m"
		end
		##
		# Determines if a string can be a float or integer.
		def self.isNumeric?(s)
			true if Float(s) rescue false
		end
		##
		# Checks if supplied options follow the rules.
		def self.checkOptions(options, rules)
			match=true
			for o in options.keys
				o_match=false
				if rules[o].class==Array
					if rules[o].include?(options[o])
						o_match=true
					else
						for r in 0...rules[o].length
							if rules[o][r].class==Hash
								for n in rules[o][r][:class]
									if n==options[o].class
										o_match=match
										break
									end
								end
							end
							if o_match==true
								break
							end
						end
					end
				elsif rules[o] == :anything
					o_match = true
				end
				match=(match and o_match)
				if match==false
					break
				end
			end
			return match
		end
		##
		# Pixel sorting helper to eliminate repetition.
		def self.handlePixelSort(band, o)
			if (o[:reverse].class == String and (o[:reverse].downcase == "reverse" or o[:reverse] == "")) or o[:reverse] == true
				reverse = 1
			elsif o[:reverse].class == String and o[:reverse].downcase == "either"
				reverse = -1
			else
				reverse = 0
			end
			if o[:smooth]
				u = band.group_by { |x| x }
				k = u.keys
			else
				k = band
			end
			sortedBand = Pxlsrt::Colors.pixelSort(
				k,
				o[:method],
				reverse
			)
			sortedBand = sortedBand.map { |x| u[x] }.flatten(1) if o[:smooth]
			return Pxlsrt::Lines.handleMiddlate(sortedBand, o[:middle])
		end
		##
		# Prints an error message.
		def self.error(what)
			puts "#{Pxlsrt::Helpers.red("pxlsrt")} #{what}"
		end
		##
		# Prints something.
		def self.verbose(what)
			puts "#{Pxlsrt::Helpers.cyan("pxlsrt")} #{what}"
		end
		##
		# Progress indication.
		def self.progress(what, amount, outof)
			progress = (amount.to_f * 100.0 / outof.to_f).to_i
			if progress == 100
				puts "\r#{Pxlsrt::Helpers.green("pxlsrt")} #{what} (#{Pxlsrt::Helpers.green("#{progress}%")})"
			else
				$stdout.write "\r#{Pxlsrt::Helpers.yellow("pxlsrt")} #{what} (#{Pxlsrt::Helpers.yellow("#{progress}%")})"
				$stdout.flush
			end
		end
	end
end