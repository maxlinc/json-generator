module JSON
	module Generator
		class BasicAttribute
			def initialize properties
				@props = properties
			end

			def generate
				@props["default"] || self.class::DEFAULT_VALUE
			end
		end
	end
end
