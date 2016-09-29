#Implements logic for Hazard
class Hazard
  #Static variables seemed like the simplest way to go about things
  @@main =0
  @@chance
  @@fiveNine = {:nicks => [@@main], :outs => [2, 3, 11, 12]}
  @@sixEight = {:nicks => [@@main, 12], :outs => [2, 3, 11]}
  @@seven = {:nicks => [@@main, 11], :outs => [2, 3, 12]}
  @@roleArray= [@@fiveNine, @@sixEight, @@seven, @@sixEight, @@fiveNine]
  @@usefulRef
  @@keepGoing=true

  #Roles two dice
  def diceRole
    d = [0, 0]
    2.times do
    |i|
      d[i] = rand(6)+1
    end
    sum=d[0]+d[1]
    p d
    p sum
  end


  def setMain(role)
    if role <10 && role>4
      @@main=role
      p "main set to #{role}"
      @@usefulRef= role%5
      #best way I could find to set the main
      @@roleArray[@@usefulRef][:nicks].shift
      @@roleArray[@@usefulRef][:nicks].unshift(@@main)
    else
      p "Role Again"
      gets
      setMain(diceRole)
    end
  end

  def setChance(role)
    if @@roleArray[@@usefulRef][:outs].include? role
      p "You Lose"
      @@keepGoing=false
    else
      if @@roleArray[@@usefulRef][:nicks].include? role
        p "You Win!"
        @@keepGoing=false
      else
        @@chance=role
        p "Chance set to #{role}"
        @@roleArray[@@usefulRef][:outs].clear
        @@roleArray[@@usefulRef][:nicks].clear
        @@roleArray[@@usefulRef][:outs].unshift(@@main)
        @@roleArray[@@usefulRef][:nicks].unshift(@@chance)
        #prints this out in case user doesn't know the nicks or outs for each case
        p @@roleArray[@@usefulRef]
      end
    end
  end

  #Play the game until an end is reached.
  def play(role)
    if @@roleArray[@@usefulRef][:nicks].include? role
      p "You Win"
      @@keepGoing=false
    else
      if @@roleArray[@@usefulRef][:outs].include? role
        p "You Lose"
        @@keepGoing=false
      else
        p "Role Again"
        gets
        play(diceRole)
      end
    end


  end

  #flag variable setter
  def cont
    @@keepGoing
  end
end

#Switches from Hazard to Craps
class GameSwitcher
  #This is modified at runtime
  def printMessage
    puts "Now Playing Chess"
  end

  #runs the actual game
  def playGame
    printMessage
    game = Hazard.new
    game.setMain(game.diceRole)
    gets
    game.setChance(game.diceRole)
    gets
#If the main was not rolled while setting chance then keep going.
    if game.cont
      game.play(game.diceRole)
    end
  end

  def pickGame
    puts "Pick a game: Enter <1> for Hazard or <2> for Craps"
    #this loop condition working seems nonsensical but it works.
    while (x=gets.chomp)
      if (x=="1")
        GameSwitcher.class_eval do
          def printMessage
            puts "Now Playing Hazard"
          end
        end
        break
      else
        #Modify the needed code to play Craps instead
        if (x=="2")
          GameSwitcher.class_eval do
            def printMessage
              puts "Now Playing Craps"
            end
          end
          GameSwitcher.class_eval do
            def playGame
              printMessage
              game = Hazard.new
              game.setMain(7)
              gets
              game.setChance(game.diceRole)
              gets
#If the main was not rolled while setting chance then keep rolling.
              if game.cont
                game.play(game.diceRole)
              end
            end
          end
          break
        end
      end
      #error response
      puts "Enter a valid option"
    end
  end
end
p
z = GameSwitcher.new
z.pickGame
z.playGame