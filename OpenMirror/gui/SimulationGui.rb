# Classe permettant de créer un gui de simulation pour le projet OpenMirror
# 
# Author::      dos Santos Pedro  (pedro.d2.santos@gmail.com)
# Copyright::   Copyright (c) 2010 - dos Santos Pedro.
# Date::        17 juillet 2010
# Version::     1.0
# :title:       SimulationGui.rb
#-----------------------------------------------------------------------------------------------------------
#
#   Copyright (C) 2010 dos Santos Pedro
# 
#   This file is part of OpenMirror.
# 
#   OpenMirror is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Lesser General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
# 
#   OpenMirror is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Lesser General Public License for more details.
# 
#   You should have received a copy of the GNU Lesser General Public License
#   along with OpenMirror.  If not, see <http://www.gnu.org/licenses/>.
#
#-----------------------------------------------------------------------------------------------------------
begin Dir.chdir(File.join(File.dirname(__FILE__), "..")); $ROOTPATH = Dir.pwd; end unless defined? $ROOTPATH

__LIBPATH__ = File.join($ROOTPATH, "lib","")
__GUIPATH__ = File.join($ROOTPATH, "gui","")

require 'Qt4'
require __LIBPATH__ + 'Tag.rb'
require __LIBPATH__ + 'Action.rb'
require __LIBPATH__ + 'Event.rb'
require __GUIPATH__ + 'PopupGui.rb'

module OpenMirror
  class SimulationGui < Qt::Widget
    
    #Instance unique de l'application Qt
    @@qApp = nil
    
    __PATH__       = File.join(File.dirname(__FILE__),"")
    __CONFIGPATH__ = File.join($ROOTPATH, "config","")
    __MEDIAPATH__  = File.join(File.dirname(__FILE__),"media","")
    
    #Marges internes et externes des layout
    GLOBAL_LAYOUT_MARGIN = 15
    LAYOUT_SPACING       = 5
    LAYOUT_MARGIN        = 5

    #Taille iniale de la fenêtre
    MIN_WIDTH  = 400
    MIN_HEIGHT = 200

    #Images de la gui
    TAG_IMAGE_FILE_NAME = [
                            __MEDIAPATH__ + "nanoztag.png",
                            __MEDIAPATH__ + "nanoztag2.png",
                            __MEDIAPATH__ + "nanoztag3.png",
                            __MEDIAPATH__ + "nanoztag4.png"
                          ]
    MIRROR_IMAGE_FILE_NAME  = __PATH__ + "media/mirror.png"
    
    #Messages et constantes de texte
    WINDOW_TITLE        = "Simulateur de mir:ror"
    TAG_NUMBER_TEXT     = "Tag N° "
    MIRROR_ON_MESSAGE   = "( Mir:ror allumé )"
    MIRROR_OFF_MESSAGE  = "( Mir:ror eteint )"
    TAG_ON_MESSAGE      = "( Tag déposé )"
    TAG_OFF_MESSAGE     = "( Tag retiré )"
    MIRROR_NAME_TEXT    = "[Mir:ror]"
    STATE_LABEL         = "État: "
    MESSAGES_LABEL      = "Messages: "
    TAGS_LABEL          = "Tags: "
    ON_LABEL            = "ON"
    OFF_LABEL           = "OFF"
    
    
    #Format de la date des messages
    DATE_FORMAT = '<%H:%M:%S>' 
    
    #Variable de classe contenant l'instance du composant messages
    @@messages = nil
    
    #Configuration des tags simulés
    TAGS =      [
                  Tag.new(Tag::COMMAND[:COMMAND_READ], Tag::ACTION[:ACTION_NULL], 'Projet_OpenMirror',          ''),
                  Tag.new(Tag::COMMAND[:COMMAND_READ], Tag::ACTION[:ACTION_NULL], '101010',                     '42'),
                  Tag.new(Tag::COMMAND[:COMMAND_READ], Tag::ACTION[:ACTION_NULL], '000008d0021a053b4732bd',     ''),
                  Tag.new(Tag::COMMAND[:COMMAND_READ], Tag::ACTION[:ACTION_NULL], '000008d009f45bdb4732bd',     'userXYZ@cityH.com')
                ]
    
    #Fichier contenant la configuration des évenements
    EVENT_CONFIGURATION_FILE = __CONFIGPATH__ + "events.yml"
    
    #Slots
    slots 'mirrorON()', 'mirrorOFF()'
    
    #classe interne modélisant un composant tag
    class TagWidget < Qt::Widget
      
      #Variable de classe serant a compter le nombre de tags
      @@tagCount = 0
      
      #Slots
      slots 'tagON()', 'tagOFF()'
      
      #Texte affiché si aucune image n'est passée, ou si elle  n'existe pas
      ALTERNATE_TEXT_TAG = "[TAG]"
      
      ALTERNATE_TEXT_STYLE = "font-weight: bold; font-variant: small-caps;"
      
      #Constructeur d'un widget Tag
      def initialize(tag, image, parent = nil)
        super(parent)
        @@tagCount += 1
        @tag = tag
        
        #Vérification du type des paramètres
        raise ArgumentError, "tag doit être de type Tag", caller unless tag.is_a? Tag
        raise ArgumentError, "image doit être de type String", caller unless image.is_a? String
     
        #Création des layouts
        localeLayout = Qt::HBoxLayout.new
        tagLayout = Qt::HBoxLayout.new
        internTagLayout = Qt::VBoxLayout.new

        #Composants graphiques internes
        tagGroupBox             = Qt::GroupBox.new(trUtf8(TAG_NUMBER_TEXT + @@tagCount.to_s))
        tagGroupBox.layout      = tagLayout
        tagIdLabel              = Qt::Label.new("id: " + tag.id)
        tagDataLabel            = Qt::Label.new("data: " + tag.data)
        tagStateRadioON         = Qt::RadioButton.new(trUtf8("ON"))
        tagStateRadioOFF        = Qt::RadioButton.new(trUtf8("OFF"))
        tagStateRadioOFF.checked = true
        tagSpacerTop            = Qt::SpacerItem.new(20, 40, Qt::SizePolicy::Minimum, Qt::SizePolicy::Minimum)
        tagSpacerBottom         = Qt::SpacerItem.new(20, 40, Qt::SizePolicy::Minimum, Qt::SizePolicy::Minimum)
        tagSpacerRight          = Qt::SpacerItem.new(20, 40, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)
                
        #Labelcontenant l'image
        tagImageLabel = Qt::Label.new
        tagImageLabel.backgroundRole = Qt::Palette::Base
        tagImageLabel.setSizePolicy(Qt::SizePolicy::Maximum, Qt::SizePolicy::Maximum)
        tagImageLabel.scaledContents = true
        
        imageTag = Qt::Image.new(image)
        if(imageTag.null?)
          #Image invalide
          tagImageLabel.text = ALTERNATE_TEXT_TAG
          tagImageLabel.setStyleSheet(ALTERNATE_TEXT_STYLE)
        else
          #Image valide
          tagImageLabel.pixmap = Qt::Pixmap.fromImage(imageTag)
        end
      
        tagLayout.addWidget(tagImageLabel)
        tagLayout.addLayout(internTagLayout)
        internTagLayout.addItem(tagSpacerTop)
        internTagLayout.addWidget(tagIdLabel)
        internTagLayout.addWidget(tagDataLabel)
        internTagLayout.addItem(tagSpacerBottom)
        tagLayout.addWidget(tagStateRadioON)
        tagLayout.addWidget(tagStateRadioOFF)
        tagLayout.addItem(tagSpacerRight)
       
        setLayout(localeLayout)
        localeLayout.addWidget(tagGroupBox)
        
        #Connexion des éléments
        connect(tagStateRadioON, SIGNAL('clicked()'), self, SLOT('tagON()'))
        connect(tagStateRadioOFF, SIGNAL('clicked()'), self, SLOT('tagOFF()'))
      end
      
      private
      
      #Simuler le dépot d'un Tag
      def tagON()
        #Créer nouvelle instance de Tag, et simuler un événement
        tagSimul = Tag.new(Tag::COMMAND[:COMMAND_READ], Tag::ACTION[:ACTION_TAG_ON], @tag.id, @tag.data)
        
        #Simuler l'événement
        evenName = SimulationGui::tagSimulate(tagSimul)
        
        #Message de log
        SimulationGui::appendMessage(TAG_ON_MESSAGE + "\n\tid => " + @tag.id + "\n\tevent => " +  evenName)
      end
        
      #Simuler le retrait d'un Tag
      def tagOFF()        
        #Créer nouvelle instance de Tag, et simuler un événement
        tagSimul = Tag.new(Tag::COMMAND[:COMMAND_READ], Tag::ACTION[:ACTION_TAG_OFF], @tag.id, @tag.data)
        
        #Simuler l'événement
        evenName = SimulationGui::tagSimulate(tagSimul)
        
        #Message de log
        SimulationGui::appendMessage(TAG_ON_MESSAGE + "\n\tid => " + @tag.id + "\n\tevent => " +  evenName)
      end
    end
    
    #Constructeur du widget global 
    def initialize(qApp, parent = nil, configurationFile = EVENT_CONFIGURATION_FILE, color = nil)
      @@qApp = qApp
      super(parent)
      
      @@configurationFile = configurationFile
      
      #Construction du layout global
      globalLayout = Qt::HBoxLayout.new(self)
      globalLayout.spacing = LAYOUT_SPACING
      globalLayout.margin = GLOBAL_LAYOUT_MARGIN
      setStyleSheet("background-color: #{color}") unless color.nil?
      
      #Construction du layout gauche
      leftLayout = Qt::VBoxLayout.new      
      
      #Construction du layout droit
      rightLayout = Qt::VBoxLayout.new
      
      #Construction du layout de la vue mirror
      mirrorLayout = Qt::HBoxLayout.new
      internMirrorLayout = Qt::HBoxLayout.new
      
      #Construction du layout de la vue messages
      messagesLayout = Qt::VBoxLayout.new
      internMessagesLayout = Qt::VBoxLayout.new
      messagesList = Qt::ListWidget.new
      @@messages = messagesList
      
      #Construction du layout de la vue des tags
      tagsLayout = Qt::VBoxLayout.new
            
      #Construction de la vue du mirror
      mirrorStateGroupBox = Qt::GroupBox.new(trUtf8(STATE_LABEL))
      mirrorStateGroupBox.layout = internMirrorLayout
      mirrorStateGroupBox.backgroundRole = Qt::Palette::Base

      mirrorStateRadioON  = Qt::RadioButton.new(trUtf8(ON_LABEL))
      mirrorStateRadioOFF = Qt::RadioButton.new(trUtf8(OFF_LABEL))
      mirrorStateRadioON.checked = true
      mirrorSpacerLeft  = Qt::SpacerItem.new(20, 40, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)
      mirrorSpacerRight = Qt::SpacerItem.new(20, 40, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)
      
      #Construction du label contenant l'image du mirror
      mirrorImageLabel = Qt::Label.new
      mirrorImageLabel.backgroundRole = Qt::Palette::Base
      mirrorImageLabel.setSizePolicy(Qt::SizePolicy::Maximum, Qt::SizePolicy::Maximum)
      mirrorImageLabel.scaledContents = true
      imageMirror = Qt::Image.new(MIRROR_IMAGE_FILE_NAME)
      
      if(imageMirror.null?)
        #Image invalide
        mirrorImageLabel.text = MIRROR_NAME_TEXT
        mirrorImageLabel.setStyleSheet("font-weight: bold;" +
                                       "font-variant: small-caps;" +
                                       "background-color: #{color}")
      else
        #Image valide
        mirrorImageLabel.pixmap = Qt::Pixmap.fromImage(imageMirror)
      end
      
      #Construction de la vue messages
      messagesGroupBox = Qt::GroupBox.new(trUtf8(MESSAGES_LABEL))
      messagesGroupBox.setSizePolicy(Qt::SizePolicy::Ignored, Qt::SizePolicy::Preferred)
      messagesGroupBox.layout = internMessagesLayout

      #Construction de la vue tags
      tagsGroupBox = Qt::GroupBox.new(trUtf8(TAGS_LABEL))
      tagsGroupBox.setSizePolicy(Qt::SizePolicy::Expanding, Qt::SizePolicy::Preferred)
      tagsGroupBox.layout = tagsLayout
      
      # Mise en forme de la vue principale
      setLayout(globalLayout)
      globalLayout.addLayout(leftLayout)
      
      leftLayout.addLayout(mirrorLayout)
      
      mirrorLayout.addWidget(mirrorStateGroupBox)
      internMirrorLayout.addItem(mirrorSpacerLeft)
      internMirrorLayout.addWidget(mirrorImageLabel)
      internMirrorLayout.addWidget(mirrorStateRadioON)
      internMirrorLayout.addWidget(mirrorStateRadioOFF)
      internMirrorLayout.addItem(mirrorSpacerRight)
      
      messagesLayout.addWidget(messagesGroupBox)
      leftLayout.addLayout(messagesLayout)
      messagesLayout.addWidget(messagesList)
      
      globalLayout.addLayout(rightLayout)
      rightLayout.addWidget(tagsGroupBox)

      #Ajouter les composants tags
      TAGS.size.times do |i|
        tagsLayout.addWidget(TagWidget.new(TAGS[i], TAG_IMAGE_FILE_NAME[i % TAG_IMAGE_FILE_NAME.size]))
      end

      #Définir le titre de la fenetêtre
      setWindowTitle(trUtf8(WINDOW_TITLE))
      
      #Redimensionner à une taille spécifique
      resize(MIN_WIDTH, MIN_HEIGHT)
      
      
      #Connecter les différents widgets
      connect(mirrorStateRadioON, SIGNAL('clicked()'), self, SLOT('mirrorON()'))
      connect(mirrorStateRadioOFF, SIGNAL('clicked()'), self, SLOT('mirrorOFF()'))
      
      #Charger les évenements associés aux tags
      SimulationGui::loadEventsFromConfig
    end
    
    
    private 
    #Simuler l'exécution du driver lors d'un événement provoqué par une lecture
    def self.tagSimulate(tag)
        #Simuler l'événement
        event = Event.match(tag)
  
        if event.nil? then
          message = " * Aucun événement lancé car aucun ne correspond au tag lu."
          puts message
          win = OpenMirror::PopupGui.new(message, @@qApp)
        else          
          message = "  * Evénement lancé : " + event.to_s
          puts message
          win = OpenMirror::PopupGui.new(message, @@qApp)
        end
        puts win.show
        return event.to_s
    end
    
    #Ajouter un message dans la liste des messages
    def self.appendMessage(message)
      raise ArgumentError, "message doit être de type String", caller unless message.is_a? String
      @@messages.addItem(Qt::ListWidgetItem.new(trUtf8(Time.now.strftime(DATE_FORMAT)  + " " + message + "\n")))
    end
    
    #Chargement de la configuration en mémoire
    def self.loadEventsFromConfig
      begin
        Event.setConfiguration(@@configurationFile)
        
      rescue Errno::ENOENT
        
        errorMessage = " Impossible de charger le fichier de configuration                           \n" +
                       "   fichier introuvable, ou vous n'avez pas les droits de                     \n" +
                       "   lecture sur le fichier. (" +  @@configurationFile.to_s + ")               \n" 
                      
        puts "-----------------------------------------------------------------------------"
        puts errorMessage
        puts ""
        puts "-----------------------------------------------------------------------------"
        puts ""
        
        win = OpenMirror::PopupGui.new(errorMessage, @@qApp)
        win.show
        
      rescue Exception => exception
        puts "-----------------------------------------------------------------------------"
        puts " Erreur : " + exception.message
        puts ""
        puts exception.backtrace
        puts "-----------------------------------------------------------------------------"
        puts ""

        errorMessage = "Une erreur grave est survenue pendant\n"
                       "le chargement de la configuration"
        win = OpenMirror::PopupGui.new(errorMessage, @@qApp)
        win.show
      end
    end
    
    #Simuler le retournement du mirror en mode ON
    def mirrorON()
      #Créer nouvelle instance de Tag, et simuler un événement
      tagSimul = Tag.new(Tag::COMMAND[:COMMAND_ONOFF], Tag::ACTION[:ACTION_MIRROR_OFF], '', '')
        
      #Simuler l'événement
      eventName = SimulationGui::tagSimulate(tagSimul)
      
      #Message de log
      SimulationGui::appendMessage(MIRROR_ON_MESSAGE + "\n\tevent => " +  eventName)
    end
    
    #Simuler le retournement du mirror en mode OFF
    def mirrorOFF()
      #Créer nouvelle instance de Tag, et simuler un événement
      tagSimul = Tag.new(Tag::COMMAND[:COMMAND_ONOFF], Tag::ACTION[:ACTION_MIRROR_OFF], '', '')
        
      #Simuler l'événement
      eventName = SimulationGui::tagSimulate(tagSimul)
      
      #Message de log
      SimulationGui::appendMessage(MIRROR_OFF_MESSAGE + "\n\tevent => " +  eventName)
    end
  end
end
