require_relative "finder_helper.rb"

Finder = Module.new do

    define_method :set_words_list do |a = [] |

        a.map { |word| finder( "#{word}") { @document =~ /#{word}/i } }

    end

    extend self
end
