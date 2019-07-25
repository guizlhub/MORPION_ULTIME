
require 'bundler'
Bundler.require


#------------------------------------------------------------
#-----------------------PLAYERS------------------------------
#la classe Player permet de définir le joueur: son nom et son jeton
class Player
  attr_accessor :name, :cain, :boardplayer

#initialise la classe Player avec les valeurs de bases
  def initialize(name, cain, boardplayer)
    @name = name
    @cain = cain
    @boardplayer = boardplayer
  end

#permet mettre à jour les cases en fonction de la case choisie
  def choose_cell(cell)
    @boardplayer.choose_cell(cell, cain)
  end

#permet de lier les cellules à la classe joueur
  def cells
    @boardplayer.cells
  end

# permet de faire une boucle sur toutes les combinaisons gagnantes
  def winner?
    wins = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]]
    wins.each do |win|
      values = [cells[win[0]], cells[win[1]], cells[win[2]]]
      return true if values.include?(cain.to_s) &&
      ((values[0] == values[1]) && (values[1] == values[2]))
    end
    false
  end
  
end

#----------------------------------------------------------
#-----------------------BOARD------------------------------
# Classe définissant le plateau de jeu
class Board
  attr_accessor :cells

  def initialize
    @cells = 
    [
    "1", "2", "3",
    "4", "5", "6",
    "7", "8", "9"
    ]
  end

    #Affichage du corps du tableau (valeurs de base + lignes verticales et horizontales)
  def show_board
    hline = "│"
    vline = "─"
    cross = "┼"
    row1 = " " + cells[0..2].join(" #{hline} ")
    row2 = " " + cells[3..5].join(" #{hline} ")
    row3 = " " + cells[6..8].join(" #{hline} ")
    separator = vline * 3 + cross + vline * 3 + cross + vline * 3
    system("clear")
    puts row1
    puts separator
    puts row2
    puts separator
    puts row3
  end

  #Permet de remplacer les cellules par le signe du joueur 
  #en checkant si elles sont vides, sinon la cellule n'est pas complétée
  #et on demande à choisir une autre case
def cell_free?(number)
  cell = cells[number-1]
  if cell == "X" ||  cell == "O"
    false
  else
    true
  end
end

def choose_cell(number, cain)
  if cell_free?(number)
    cells[number-1] = cain.to_s
    show_board
  else
    puts "Case déjà remplie ! Choisis une autre case."
    return false
  end
end

end

#----------------------------------------------------------
#-----------------------GAME-------------------------------
class Game

  #On débute le jeu avec un board qu'on initialise / pas encore de gagnant 
  def initialize
    @boardplayer = Board.new
    @current_player = ""
    @winner = false
    @turn = 0
  end

#méthode permettant de lancer le jeu et de démarrer la partie et de 
#déterminer l'issue de la partie. On crée de nouveaux joueurs avec des noms 
#récupérés de la méthode 'get_names'.
def start_game
    names = get_names
    @player1 = Player.new(names[0], :X, @boardplayer)
    @player2 = Player.new(names[1], :O, @boardplayer)
    @current_player = @player1
    @boardplayer.show_board
    turn_of_game until @winner || @turn == 9
    if @winner
      puts "#{@winner.name} GAGNE!"
    else
      puts "EGALITE!"
    end
  end

  #Méthode permettant d'obtenir le nom des joueurs, on utilise le gets.chomp
  def get_names
    puts "Player X name: "
    name1 = gets.chomp
    puts "Player O name: "
    name2 = gets.chomp
    [name1, name2]
  end

 #le jouer peut entrer un nombre compris entre 1 et 9, 
 #si le nombre n'est pas compris dans cet intervalle un message 
 #s'affiche demandant de redonner une valeur
  def turn_of_game
    puts "A #{@current_player.name} de jouer. Choisis un chiffre entre 1 et 9 : "
    choice = gets.chomp.to_i
    if choice > 9 || choice < 1
      puts "ATTENTION ! Mets un chiffre entre 1 et 9"
    elsif @current_player.choose_cell(choice) != false
      @winner = @current_player if @current_player.winner?
      @turn += 1
      switch_player
    end
  end

#Méthode permettant de mettre en place les changement de joueur
  def switch_player
    @current_player = @current_player  == @player1 ? @player2 : @player1
  end

end

game = Game.new
game.start_game
