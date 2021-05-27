require 'json'
class Game
    attr_accessor :array_word, :array_show, :health_points, :already_picked
    def initialize()
        @array_word = initialize_random_word().split("")
        @already_picked = []
        @health_points = 10
        @array_show = @array_word.map {|item| item = "*"}
    end
    def guess()
        choice = "0"
        while ((choice != "1")&&(choice != "2"))
            puts "Press 1 to start a new game or 2 to load the previous saved game."
            choice = gets.chomp
        end
        if choice == "2"
            if File.file?("saved_game.json")
                string = File.read("saved_game.json")
                from_json(string)
            else
                puts "There is no previous saved game!"
            end
        end
        @array_word[0].downcase! if @array_word[0] == @array_word[0].upcase
        puts @array_word.join(" ")
        guessed = false
        while ((@health_points != 0)&&(guessed == false))
            puts "You can only fail #{@health_points} times."
            puts @array_show.join(" ")
            puts ""
            letter = ""
            while letter.length != 1
                puts "Guess a letter! (if you input 'save' you will save the state of the match)"
                letter = gets.chomp
                if letter == "save"
                    File.open("saved_game.json", "w") {|f| f.write(to_json()) }
                    puts "The game has benn saved!"
                end
                letter.downcase! if letter == letter.upcase
                puts ""
            end
            @already_picked.push(letter)
            puts "Already chosen charachters: #{@already_picked.join(" ")}"
            if @array_word.include?(letter)
                puts "Correct Guess!"
                puts ""
                @array_word.each_with_index do |item, index|
                    if item == letter
                        @array_show[index] = letter
                    end
                end
            else
                puts "Wrong guess :("
                puts ""
                @health_points -= 1 
            end
            if @array_show.include?("*")
                guessed = false
            else
                guessed = true
                puts @array_show.join(" ")
                puts "You guessed the word!"
            end
            puts "You lost! :S" if @health_points == 0
        end
    end

    private
    def to_json
        JSON.dump ({
          :array_word => @array_word,
          :array_show => @array_show,
          :health_points => @health_points,
          :already_picked => @already_picked
        })
    end
    
    def from_json(string)
        data = JSON.load string
        @array_word = data['array_word']
        @array_show = data['array_show']
        @already_picked = data['already_picked']
        @health_points = data['health_points']
    end
    
    def initialize_random_word()
        words = File.read "5desk.txt"
        words = words.split(/\R+/)
        words = words.reject {|item| item.length < 5}
        length = words.length
        random_word = words[rand(1..length)]
    end
end

match = Game.new
match.guess()






