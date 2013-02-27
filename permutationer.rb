# add html.erb to Tilt, sinatra's rendering engine
Tilt.register Tilt::ERBTemplate, 'html.erb'

class Permutationer < Sinatra::Base
  get '/' do
    erb :index
  end

  post '/results' do

    # Get keyword list
    @list_a = params["word-list-a"]
    @list_b = params["word-list-b"]
    @list_c = params["word-list-c"]
    
    # Get the concatenation options
    @concatenation_options = params["concatenation-options"]

    # Concatenate the results
    @results = Array.new
    if @concatenation_options
      Concatenate.concatenate_1(@list_a, @results) if @concatenation_options['a']
      Concatenate.concatenate_1(@list_b, @results) if @concatenation_options['b']
      Concatenate.concatenate_1(@list_c, @results) if @concatenation_options['c']

      Concatenate.concatenate_2(@list_a, @list_b, @results) if @concatenation_options['a_b']
      Concatenate.concatenate_2(@list_b, @list_a, @results) if @concatenation_options['b_a']
      Concatenate.concatenate_2(@list_a, @list_c, @results) if @concatenation_options['a_c']
      Concatenate.concatenate_2(@list_c, @list_a, @results) if @concatenation_options['c_a']
      Concatenate.concatenate_2(@list_b, @list_c, @results) if @concatenation_options['b_c']
      Concatenate.concatenate_2(@list_c, @list_b, @results) if @concatenation_options['c_b']

      Concatenate.concatenate_3(@list_a, @list_b, @list_c, @results) if @concatenation_options['a_b_c']
      Concatenate.concatenate_3(@list_c, @list_b, @list_a, @results) if @concatenation_options['c_b_a']
      Concatenate.concatenate_3(@list_a, @list_c, @list_b, @results) if @concatenation_options['a_c_b']
      Concatenate.concatenate_3(@list_b, @list_c, @list_a, @results) if @concatenation_options['b_c_a']
      Concatenate.concatenate_3(@list_b, @list_a, @list_c, @results) if @concatenation_options['b_a_c']
      Concatenate.concatenate_3(@list_c, @list_a, @list_b, @results) if @concatenation_options['c_a_b']

      Concatenate.downcase(@results) if @concatenation_options['downcase']
    end

    @final_results = Concatenate.get_final_result(@results)

    @total_words = @results.count
    erb :results
  end

  not_found do
    status 404
    "oh no, not found"
  end

  get '/robots.txt' do
    File.read('robots.txt')
  end

  get '/humans.txt' do
    File.read('humans.txt')
  end
end

module Concatenate
  # Single concatenation
  def self.concatenate_1(list_1, results)
    # Transform list_1 array into smaller arrays based on line return
    words = list_1.split("\r\n")

    # Push the words to result Array
    words.each do |word|
      results.push word
    end

    return results
  end

  # Double concatenation
  def self.concatenate_2(list_1, list_2, results)
    # Transform list_1 & list_2 arrays into smaller arrays based on line return
    word_list_1 = list_1.split("\r\n")
    word_list_2 = list_2.split("\r\n")

    # Concatenate like a boss
    word_list_1.each do |loop_1|
      word_list_2.each do |loop_2|
        results.push (loop_1.chomp + " " + loop_2)
      end
    end

    return results
  end

  # Triple concatenation
  def self.concatenate_3(list_1, list_2, list_3, results)
    # Transform list arrays into smaller arrays based on line return
    word_list_1 = list_1.split("\r\n")
    word_list_2 = list_2.split("\r\n")
    word_list_3 = list_3.split("\r\n")

    # Err day I concatenate
    word_list_1.each do |loop_1|
      word_list_2.each do |loop_2|
        word_list_3.each do |loop_3|
          results.push (loop_1.chomp + " " + loop_2.chomp + " " + loop_3)
        end
      end
    end

    return results
  end

  # Set result to downcase
  def self.downcase(results)
    results.each do |r| 
      r.replace r.downcase
    end
    return results
  end

  # Create the final results
  def self.get_final_result(results)
    # Use .squeeze to remove double white spaces "  "
    # and use .strip to remove leading and trailing white spaces
    results = results.collect{ |r| r.squeeze(" ").strip }

    # Transform results from array into a string 
    # Add a line return ("\n") for each keyword
    final_results = results * "\n"
    
    return final_results
  end
end