# Classe permettant de créer un gui de configuration pour les OpenMirror::Events
# 
# Author::      dos Santos Pedro  (pedro.d2.santos@gmail.com)
# Copyright::   Copyright (c) 2010 - dos Santos Pedro.
# Date::        17 juillet 2010
# Version::     1.0
# :title:       ConfigurationGui.rb
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
require __GUIPATH__ + 'CustomDialog.rb'

module OpenMirror
  class ConfigurationGui < Qt::Widget
    
    __PATH__                    = File.join(File.dirname(__FILE__),"")
    __CONFIGPATH__              = File.join($ROOTPATH, "config","")
    __MEDIAPATH__               = File.join(File.dirname(__FILE__),"media","""")
    
    #Marges internes et externes des layout
    GLOBAL_LAYOUT_MARGIN        = 20
    LAYOUT_SPACING              = 10

    #Taille iniale de la fenêtre
    MIN_WIDTH                   = 800
    MIN_HEIGHT                  = 800
    
    #Fichier contenant la configuration des évenements (par défaut)
    EVENT_CONFIGURATION_FILE    = __CONFIGPATH__ + "events.yml"
    
    #Icones utilisés
    ADD_ICON                    = __MEDIAPATH__ + "add.png"
    REMOVE_ICON                 = __MEDIAPATH__ + "remove.png"
    EDIT_ICON                   = __MEDIAPATH__ + "edit.png"
    UP_ICON                     = __MEDIAPATH__ + "up.png"
    DOWN_ICON                   = __MEDIAPATH__ + "down.png"

    #Chaines de texte du programme
    #--Titre de la fênetre
    WINDOW_TITLE = "Configuration des events"
    
    #--Labels Titres
    LABEL_EVENT                 = "Events"
    LABEL_MATCHES               = "Matches"
    LABEL_ACTIONS               = "Actions"
    LABEL_NAME                  = "Nom:"   
    
    #--Tooltips des bouttons
    EVENT_ADD_BUTTON_TT         = "Ajouter event"
    EVENT_REMOVE_BUTTON_TT      = "Supprimer event"
    EVENT_UP_BUTTON_TT          = "Monter"
    EVENT_DOWN_BUTTON_TT        = "Descendre"
    EVENT_NAME_EDIT             = "Éditer nom"
        
    MATCHES_ADD_BUTTON_TT       = "Ajouter match"
    MATCHES_EDIT_BUTTON_TT      = "Éditer match"
    MATCHES_REMOVE_BUTTON_TT    = "Supprimer match"
    
    ACTIONS_ADD_BUTTON_TT       = "Ajouter action"
    ACTIONS_EDIT_BUTTON_TT      = "Éditer action"
    ACTIONS_REMOVE_BUTTON_TT    = "Supprimer action"
    
    #--Menus et actions
    FILE_MENU                   = "Fichier"
    HELP_MENU                   = "Aide"
      
    NEW_CONFIG_ACTION           = "&Nouvelle configuration"
    SAVE_CONFIG_ACTION          = "&Sauvegarder"
    IMPORT_CONFIG_ACTION        = "&Importer configuration"
    EXPORT_CONFIG_ACTION        = "&Exporter configuration"
    QUIT_ACTION                 = "&Quitter"
    HELP_ACTION                 = "Aide sur l'utilisation de ce logiciel"
    ABOUT_OPEN_MIRROR_ACTION    = "À proppos d'OpenMirror"
    ABOUT_QT_ACTION             = "À propos de Qt"
    
    #--Raccourcis
    NEW_CONFIG_SHORTCUT         = "Ctrl+N"
    SAVE_CONFIG_SHORTCUT        = "Ctrl+S"
    IMPORT_CONFIG_SHORTCUT      = "Ctrl+I"
    EXPORT_CONFIG_SHORTCUT      = "Ctrl+E"
    QUIT_CONFIG_SHORTCUT        = "Ctrl+Q"
    
    #--Page d'à propos
    ABOUT_HTML_CONTENT          = "<img src=#{__MEDIAPATH__ + "OpenMirror.png"} alt='OpenMirror'/><br/><hr/>" +
                                  "L'outil de configuration fait partie de la suite OpenMirror.<br/><br/>" +
                                  "L'intégralité du projet est disponnible <a href='http://github.com/Psantos/openMirror'> ici </a> (http://github.com/Psantos/openMirror)"
     
    #--Help
    HELP_OPENMIRROR_TEXT        = "Désolé, actuellement aucune aide n'est ingtégrée à l'application. \n" +
                                  "Référerez vous à l'aide livrée avec le code source du projet,     \n" +
                                  "ou consultez le page d'accueil du projet (http://github.com/Psantos/openMirror)"
  
    #--Chargement de la configuration Erreurs
    LOAD_ARGUMENT_ERROR         = "configFile doit être de type String"
    
    LOAD_ERROR                  = "Impossible de charger le fichier de configuration \n" +
                                  "  Le fichier est introuvable ou vous n'avez pas   \n" +
                                  "  les droits de lecture sur le fichier.           \n"
    
    LOAD_SERIOUS_ERROR          = "Une erreur grave est survenue pendant\n"
                                  "le chargement de la configuration"
                                                              
    #--Dialogue ajout event
    EVENT_NAME_ADD              = "Saisissez le nom de l'event"
    EVENT_SEQ_MATCH_ADD         = "Voulez vous ajouter un match à ce nouvel event?"
    EVENT_SEQ_MATCH_ADD_AGAIN   = "Voulez vous ajouter un autre match à ce nouvel event?"
    EVENT_SEQ_ACTION_ADD        = "Voulez vous ajouter une action à ce nouvel event?"
    EVENT_SEQ_ACTION_ADD_AGAIN  = "Voulez vous ajouter une autre action à ce nouvel event?"

    
    #--Dialogue edition nom event
    EVENT_NAME_EDIT_TEXT        = "Saisissez le nouveau nom de l'event"
    
    #--Dialogue exporter
    EXPORT_DIALOG_TITLE         = "Veuillez sélectionnez le fichier d'exportation"
    
    EXPORT_FILE_ERROR           = " Impossible d'enregistrer le fichier de configuration \n" +
                                  "  à l'endroit spécifié. Vous n'avez pas les droits    \n" +
                                  "  d'écriture sur le dossier sélectionné.              \n"
    
    EXPORT_SERIOUS_ERROR        = "Une erreur grave est survenue pendant\n"
                                  "l'exportation de la configuration"

                                  
    #--Dialogue importer
    IMPORT_DIALOG_TITLE         = "Veuillez sélectionnez le fichier d'importation"
    
    IMPORT_FILE_ERROR           = " Impossible de charger le fichier de configuration    \n" +
                                  "  à l'endroit spécifié. Vous n'avez pas les droits    \n" +
                                  "  de lecture sur le fichier sélectionné.              \n"
    
    IMPORT_SERIOUS_ERROR        = "Une erreur grave est survenue pendant\n"
                                  "l'importation de la configuration"

    #Dialogue remove event
    EVENT_REMOVE_TEXT           = "Êtes vous sur de vouloir supprimer cet élément?"
    
    #Dialogue remove match
    MATCH_REMOVE_TEXT           = "Êtes vous sur de vouloir supprimer cet élément?"

    #Dialogue remove action
    ACTION_REMOVE_TEXT          = "Êtes vous sur de vouloir supprimer cet élément?"

    #Dialogue add match
    MATCH_ADD_FIELD_TEXT        = "Veuillez sélectionner le champ du tag pour le matching"
    MATCH_ADD_VALUE_TEXT        = "Veuillez saisir la valeur de matching "
    MATCH_FIELDS                = ['ID', 'DATA', 'COMMAND', 'ACTION']
    MATCH_VALUES_CONSTANTS      = {
                                    'COMMAND'    => ['COMMAND_ONOFF', 'COMMAND_READ' ] ,
                                    'ACTION'     => ['ACTION_TAG_ON', 'ACTION_TAG_OFF', 'ACTION_MIRROR_ON', 'ACTION_MIRROR_OFF' ]
                                  }
    MATCH_VALUES_REGEX          = {
                                    'ID'        => nil
                                  }
    
    #Modes de saisie
    INPUT_MODE_TEXT             = "Veuillez sélectionner la méthode de saisie"
    INPUT_MODES                 = {
                                      :STRING    => "Saisir une chaîne de caractères",
                                      :INTEGER   => "Saisir une valeur entière",
                                      :REGEX     => "Saisie une expréssion régulière",
                                      :CONSTANTS => "Sélectionner une constante parmi un ensemble de valeurs finies"
                                  }
    
    #Dialoge add action
    ACTION_ADD_FIELD_TEXT               = "Veuillez sélectionner le type d'action"
    ACTION_TYPES                        = ['SYSTEM_COMMAND', 'HTTP_REQUEST']
    ACTION_HTTP_METHODS_TEXT            = "Veuillez sélectionner la méthode HTTP"
    ACTION_HTTP_URL_TEXT                = "Veuillez saisir l'uri de votre ressource"
    ACTION_HTTP_HEADERS_TEXT_ASK        = "Voulez vous saisir des headers HTTP?"
    ACTION_HTTP_HEADERS_TEXT_FIELD      = "Veuillez saisir le champ du header"
    ACTION_HTTP_HEADERS_TEXT_VALUE      = "Veuillez saisir la valeur correspondante"
    ACTION_HTTP_HEADERS_TEXT_ASK_AGAIN  = "Voulez-vous ajouter un autre header?"
    ACTION_HTTP_PARAMS_TEXT_ASK         = "Voulez-vous ajouter des params HTTP?"
    ACTION_HTTP_PARAMS_TEXT_FIELD       = "Veuillez saisir le champ du params"
    ACTION_HTTP_PARAMS_TEXT_VALUE       = "Veuillez saisir la valeur correspondante"
    ACTION_HTTP_PARAMS_TEXT_ASK_AGAIN   = "Voulez-vous ajouter un autre params?"
    ACTION_HTTP_DATA_TEXT_ASK           = "Voulez-vous ajouter des datas HTTP?"
    ACTION_HTTP_DATA_TEXT_VALUE         = "Veuillez saisir les datas sous forme de châine de caractères"
    
    
    #Instance unique de l'application Qt
    @@qApp = nil
    
    #Liste des events chargés
    @@loadedEventsList = []
    
    #Booléen indiquand l'état de la configuration (si modifé est pas sauvegardé)
    @@modified = false

    #Slots de la classe
    slots 'showDetails(QListWidgetItem*)', 
          'newFile()',
          'import()',
          'export()',
          'save()',
          'showAboutOpenMirror()',
          'showHelpOpenMirror()',
          'moveEventUp()',
          'moveEventDown()',
          'editEventName()',
          'eventRemove()',
          'matchRemove()',
          'actionRemove()',
          'eventAdd()',
          'matchAdd()',
          'actionAdd()',
          'matchEdit()',
          'actionEdit()'

       
    # Constructeur du widget
    def initialize(qApp, parent = nil, configurationFile = EVENT_CONFIGURATION_FILE, color = nil)
      @@qApp = qApp
      super(parent)
      
      #Fichier source de la configuration
      @@configurationFile = configurationFile
      
      #Définir le titre de la fenetêtre
      setWindowTitle(trUtf8(WINDOW_TITLE))
      
      #Redimensionner à une taille spécifique
      resize(MIN_WIDTH, MIN_HEIGHT)
      
      #Charger la configuration depuis le fichier
      #Création des icones
      actionAddIcon     = Qt::Icon.new(ADD_ICON)
      actionEditIcon    = Qt::Icon.new(EDIT_ICON)
      actionRemoveIcon  = Qt::Icon.new(REMOVE_ICON)
      actionUpIcon      = Qt::Icon.new(UP_ICON)
      actionDownIcon    = Qt::Icon.new(DOWN_ICON)
      
      #Construction du layout global
      globalLayout = Qt::HBoxLayout.new(self)
      globalLayout.spacing = LAYOUT_SPACING
      globalLayout.margin = GLOBAL_LAYOUT_MARGIN
      setStyleSheet("background-color: #{color}") unless color.nil?
      setLayout(globalLayout)      
      
      #Construction du layout gauche
      leftLayout = Qt::VBoxLayout.new      
      globalLayout.addLayout(leftLayout)
      
      #Construction du layout droit
      rightLayout = Qt::VBoxLayout.new
      globalLayout.addLayout(rightLayout)
      
      #Construction de la vue gauche, liste des evenements
      eventListInternLayout    = Qt::VBoxLayout.new
      eventListGroupBox        = Qt::GroupBox.new(trUtf8(LABEL_EVENT))
      eventListGroupBox.layout = eventListInternLayout
                 
      eventListActionsLayout = Qt::HBoxLayout.new
      eventListInternLayout.addLayout(eventListActionsLayout)
      leftLayout.addWidget(eventListGroupBox)
      
      @eventList = Qt::ListWidget.new
      eventListInternLayout.addWidget(@eventList)
      
      eventAddButton    = Qt::PushButton.new(actionAddIcon, '')
      eventRemoveButton = Qt::PushButton.new(actionRemoveIcon, '')
      eventUpButton     = Qt::PushButton.new(actionUpIcon, '')
      eventDownButton   = Qt::PushButton.new(actionDownIcon, '')
      
      eventAddButton.toolTip    = trUtf8(EVENT_ADD_BUTTON_TT)
      eventRemoveButton.toolTip = trUtf8(EVENT_REMOVE_BUTTON_TT)
      eventUpButton.toolTip     = trUtf8(EVENT_UP_BUTTON_TT)
      eventDownButton.toolTip   = trUtf8(EVENT_DOWN_BUTTON_TT)
        
      eventListActionsLayout.addWidget(eventAddButton)
      eventListActionsLayout.addWidget(eventRemoveButton)
      eventListActionsLayout.addWidget(eventUpButton)
      eventListActionsLayout.addWidget(eventDownButton)
      
      #Construction de la vue droite (details et actions)
      eventNameLayout           = Qt::HBoxLayout.new
      eventMatchesLayout        = Qt::VBoxLayout.new
      eventMatchesInternLayout  = Qt::VBoxLayout.new
      eventMatchesButtonsLayout = Qt::HBoxLayout.new
      eventActionsLayout        = Qt::VBoxLayout.new
      eventActionsInternLayout  = Qt::VBoxLayout.new
      eventActionsButtonsLayout = Qt::HBoxLayout.new
      
      #--Nom de l'évenement
      eventNameTitleLabel  = Qt::Label.new(trUtf8(LABEL_NAME))
      eventNameSpacerRight = Qt::SpacerItem.new(20, 40, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)
      eventNameEditButton  = Qt::PushButton.new(actionEditIcon, '')
      eventNameEditButton.toolTip = trUtf8(EVENT_NAME_EDIT)
      
      @eventNameLabel      = Qt::Label.new
      
      eventNameLayout.addWidget(eventNameTitleLabel)
      eventNameLayout.addWidget(@eventNameLabel)
      eventNameLayout.addItem(eventNameSpacerRight)
      eventNameLayout.addWidget(eventNameEditButton)
      rightLayout.addLayout(eventNameLayout)
      
      #--Matches
      eventMatchesGroupBox = Qt::GroupBox.new(trUtf8(LABEL_MATCHES))
      @eventMatchesList = Qt::ListWidget.new
      eventMatchesLayout.addWidget(eventMatchesGroupBox)
      eventMatchesGroupBox.layout = eventMatchesInternLayout
      eventMatchesInternLayout.addWidget(@eventMatchesList)
      eventMatchesInternLayout.addLayout(eventMatchesButtonsLayout)
      
      matchesAddButton    = Qt::PushButton.new(actionAddIcon, '')
      matchesEditButton   = Qt::PushButton.new(actionEditIcon, '')
      matchesRemoveButton = Qt::PushButton.new(actionRemoveIcon, '')
        
      matchesAddButton.toolTip    = trUtf8(MATCHES_ADD_BUTTON_TT)
      matchesEditButton.toolTip   = trUtf8(MATCHES_EDIT_BUTTON_TT)
      matchesRemoveButton.toolTip = trUtf8(MATCHES_REMOVE_BUTTON_TT)
        
      eventMatchesButtonsLayout.addWidget(matchesAddButton)
      eventMatchesButtonsLayout.addWidget(matchesEditButton)
      eventMatchesButtonsLayout.addWidget(matchesRemoveButton)
      rightLayout.addLayout(eventMatchesLayout)
      
      #--Actions
      eventActionsGroupBox = Qt::GroupBox.new(trUtf8(LABEL_ACTIONS))
      @eventActionsList = Qt::ListWidget.new
      eventActionsLayout.addWidget(eventActionsGroupBox)
      eventActionsGroupBox.layout = eventActionsInternLayout
      eventActionsInternLayout.addWidget(@eventActionsList)
      eventActionsInternLayout.addLayout(eventActionsButtonsLayout)
      
      actionsAddButton    = Qt::PushButton.new(actionAddIcon, '')
      actionsEditButton   = Qt::PushButton.new(actionEditIcon, '')
      actionsRemoveButton = Qt::PushButton.new(actionRemoveIcon, '')
      
      actionsAddButton.toolTip    = trUtf8(ACTIONS_ADD_BUTTON_TT)
      actionsEditButton.toolTip   = trUtf8(ACTIONS_EDIT_BUTTON_TT)
      actionsRemoveButton.toolTip = trUtf8(ACTIONS_REMOVE_BUTTON_TT)
      
      eventActionsButtonsLayout.addWidget(actionsAddButton)
      eventActionsButtonsLayout.addWidget(actionsEditButton)
      eventActionsButtonsLayout.addWidget(actionsRemoveButton)
      rightLayout.addLayout(eventActionsLayout)
           
      #Création des menus
      menuBar  = Qt::MenuBar.new(self)      
      fileMenu = Qt::Menu.new(trUtf8(FILE_MENU))
      helpMenu = Qt::Menu.new(trUtf8(HELP_MENU))
      
      menuBar.addMenu(fileMenu)
      menuBar.addMenu(helpMenu)
      
      #--Création des actions      
      newAction             = Qt::Action.new(trUtf8(NEW_CONFIG_ACTION), self)
      newAction.shortcut    = Qt::KeySequence.new(trUtf8(NEW_CONFIG_SHORTCUT))
      
      saveAction            = Qt::Action.new(trUtf8(SAVE_CONFIG_ACTION), self)
      saveAction.shortcut   = Qt::KeySequence.new(trUtf8(SAVE_CONFIG_SHORTCUT))
      
      importAction          = Qt::Action.new(trUtf8(IMPORT_CONFIG_ACTION), self)
      importAction.shortcut = Qt::KeySequence.new(trUtf8(IMPORT_CONFIG_SHORTCUT))
      
      exportAction          = Qt::Action.new(trUtf8(EXPORT_CONFIG_ACTION), self)
      exportAction.shortcut = Qt::KeySequence.new(trUtf8(EXPORT_CONFIG_SHORTCUT))
      
      quitAction            = Qt::Action.new(trUtf8(QUIT_ACTION), self)
      quitAction.shortcut   = Qt::KeySequence.new(trUtf8(QUIT_CONFIG_SHORTCUT))
      
      configHelpAction      = Qt::Action.new(trUtf8(HELP_ACTION), self)
      openMirrorAboutAction = Qt::Action.new(trUtf8(ABOUT_OPEN_MIRROR_ACTION), self)
      qtAboutAction         = Qt::Action.new(trUtf8(ABOUT_QT_ACTION), self)
            
      #--Ajout des actions aux menus
      fileMenu.addAction(newAction)
      fileMenu.addAction(saveAction)
      fileMenu.addAction(importAction)
      fileMenu.addAction(exportAction)
      fileMenu.addAction(quitAction)
      
      helpMenu.addAction(configHelpAction)
      helpMenu.addAction(openMirrorAboutAction)
      helpMenu.addAction(qtAboutAction)

      #Chargement de la configuration par défaut
      loadEventsFromConfig(@@configurationFile)
      modified(false)
              
      #Connexions des widgets graphiques
      connect(@eventList,               SIGNAL('itemActivated(QListWidgetItem*)'), self, SLOT('showDetails(QListWidgetItem*)'))    
      connect(@eventList,               SIGNAL('itemClicked(QListWidgetItem*)'), self, SLOT('showDetails(QListWidgetItem*)'))    
      
      connect(newAction,                SIGNAL('triggered()'),  self,   SLOT('newFile()'))
      connect(saveAction,               SIGNAL('triggered()'),  self,   SLOT('save()'))
      connect(exportAction,             SIGNAL('triggered()'),  self,   SLOT('export()'))
      connect(importAction,             SIGNAL('triggered()'),  self,   SLOT('import()'))
      connect(quitAction,               SIGNAL('triggered()'),  @@qApp, SLOT('quit()'))
      
      connect(qtAboutAction,            SIGNAL('triggered()'),  @@qApp, SLOT('aboutQt()'))
      connect(openMirrorAboutAction,    SIGNAL('triggered()'),  self,   SLOT('showAboutOpenMirror()'))
      connect(configHelpAction,         SIGNAL('triggered()'),  self,   SLOT('showHelpOpenMirror()'))
            
      connect(eventNameEditButton,      SIGNAL('clicked()'),    self,   SLOT('editEventName()'))
      connect(eventUpButton,            SIGNAL('clicked()'),    self,   SLOT('moveEventUp()'))
      connect(eventDownButton,          SIGNAL('clicked()'),    self,   SLOT('moveEventDown()'))
      connect(eventRemoveButton,        SIGNAL('clicked()'),    self,   SLOT('eventRemove()'))
      connect(eventAddButton,           SIGNAL('clicked()'),    self,   SLOT('eventAdd()'))

      connect(matchesAddButton,         SIGNAL('clicked()'),    self,   SLOT('matchAdd()'))
      connect(matchesRemoveButton,      SIGNAL('clicked()'),    self,   SLOT('matchRemove()'))
      connect(matchesEditButton,        SIGNAL('clicked()'),    self,   SLOT('matchEdit()'))

      
      connect(actionsAddButton,         SIGNAL('clicked()'),    self,   SLOT('actionAdd()'))
      connect(actionsRemoveButton,      SIGNAL('clicked()'),    self,   SLOT('actionRemove()'))
      connect(actionsEditButton,        SIGNAL('clicked()'),    self,   SLOT('actionEdit()'))
    end
   
    private
    
    #Charger en mémoire les events configurés 
    def loadEventsFromConfig(configFile) 
      raise ArgumentError, LOAD_ARGUMENT_ERROR, caller unless configFile.is_a? String
      
      begin
        #On démarre avec une vue et un modele vide
        newFile()
        #Chargement depuis YAML
        @@loadedEventsList = YAML.load(open(configFile))        
        
        #Lister les items de la config par nom
        @@loadedEventsList.each do |i|
          @eventList.addItem(Qt::ListWidgetItem.new(trUtf8(i.name)))
        end
                
      rescue Errno::ENOENT
        
        puts "-----------------------------------------------------------------------------"
        puts LOAD_ERROR
        puts ""
        puts "-----------------------------------------------------------------------------"
        puts ""
        
        win = OpenMirror::PopupGui.new(LOAD_ERROR, @@qApp)
        win.show
        
      rescue Exception => exception
        puts "-----------------------------------------------------------------------------"
        puts " Erreur : " + exception.message
        puts ""
        puts exception.backtrace
        puts "-----------------------------------------------------------------------------"
        puts ""

        win = OpenMirror::PopupGui.new(LOAD_SERIOUS_ERROR, @@qApp)
        win.show
      end
    end
    
    #Affiche la fenêtre à propos d'OpenMirror
    def showAboutOpenMirror
      about = Qt::MessageBox.information(self, 'About', trUtf8(ABOUT_HTML_CONTENT))
    end
    
    #Afficher l'aide sur l'interface de configuration et sur OpenMirror
    def showHelpOpenMirror
      about = Qt::MessageBox.information(self, 'About', trUtf8(HELP_OPENMIRROR_TEXT))
    end
        
    #Afficher les détails d'un event selectionné
    def showDetails(item)
      #effacer les vues de droite
      @eventMatchesList.clear
      @eventActionsList.clear

      #afficher les details pour un item valide
      if(!item.nil?) 
        #Afficher le nom de l'event
        @eventNameLabel.text = item.text.to_s
        
        #Peupler les matches de l'event
        @@loadedEventsList[@eventList.currentRow].matches.each do |match|
          @eventMatchesList.addItem(Qt::ListWidgetItem.new(trUtf8(match.field.to_s + " \t=> " + match.value.to_s)))
        end
      
        #Peupler les actions de l'event
        @@loadedEventsList[@eventList.currentRow].actions.each do |action|
          @eventActionsList.addItem(Qt::ListWidgetItem.new(trUtf8('[' + action.class.to_s.gsub("OpenMirror::Action::",'') + '] : ' + action.to_s )))
        end 
      end
    end
    
    def modified(state)
      if(state) then
        @@modified = true
        setWindowTitle(trUtf8(WINDOW_TITLE + '*'))
      else
        @@modified = false
        setWindowTitle(trUtf8(WINDOW_TITLE))
      end
    end
    
    
    #Nouvelle configuration
    def newFile()
      #indiquer que la configuration à été modifiée
      modified(true)
      
      @@loadedEventsList = []
      @eventList.clear
      @eventActionsList.clear
      @eventMatchesList.clear
    end
    
    #Sauver la configuration dans le fichier de configuration par défaut
    def save()
      file = File.open(@@configurationFile, 'w')
      file.write(@@loadedEventsList.to_yaml)
      file.close
      modified(false)
    end
    
    
    #déplacer un event vers le haut
    def moveEventUp()
      #Uniquement si un event est séléctionné
      if(@eventList.isItemSelected(@eventList.currentItem)) then
        itemRow = @eventList.currentRow
        if((itemRow != 0) and (itemRow >= 0)) then
          #modifier la configuration en mémoire
          @@loadedEventsList.swap!(itemRow, itemRow - 1)
          
          #indiquer que la configuration à été modifiée
          modified(false)
          
          #modifier la vue
          @eventList.insertItem(itemRow -1, @eventList.takeItem(itemRow))
          @eventList.currentRow = itemRow -1
        end
      end
    end
    
    #deplacer un event vers le bas
    def moveEventDown()
      #Uniquement si un event est séléctionné
      if(@eventList.isItemSelected(@eventList.currentItem)) then
        itemRow = @eventList.currentRow
        if((itemRow != @eventList.count - 1) and (itemRow >= 0)) then
          #modifier la configuration en mémoire
          @@loadedEventsList.swap!(itemRow, itemRow + 1)
          
          #indiquer que la configuration à été modifiée
          modified(true)

          #modifier la vue
          @eventList.insertItem(itemRow + 1, @eventList.takeItem(itemRow))
          @eventList.currentRow = itemRow + 1
        end
      end
    end
    
    #modifier le nom d'un event
    def editEventName()
      
      #Si un élément est selectionné
      if(@eventList.isItemSelected(@eventList.currentItem)) then
        #demander à l'utilisateur de saisir le nouveau nom
        eventName = CustomDialog.new(:LINE_EDIT, {:title => WINDOW_TITLE,  :text => EVENT_NAME_EDIT_TEXT, :defaultValue => @@loadedEventsList[@eventList.currentRow].name}).value
         
        if(!eventName.nil? and !eventName.empty?)
          #indiquer que la configuration à été modifiée
          modified(true)
          
          #modifier l'event concerné
          @@loadedEventsList[@eventList.currentRow].name = eventName
          
          #mettre à jour la vue
          @eventList.currentItem.text = eventName
          @eventNameLabel.text = eventName
        end
      end
    end
    
    #Exporter la configuration courrante
    def export()
      begin
        fname = Qt::FileDialog.getSaveFileName(self, trUtf8(EXPORT_DIALOG_TITLE))
        
        if(!fname.nil? and !fname.empty?) then
          file = File.open(fname, 'w')
          file.write(@@loadedEventsList.to_yaml)
          file.close
        end
           
      rescue Errno::EACCES
        puts "-----------------------------------------------------------------------------"
        puts EXPORT_FILE_ERROR
        puts ""
        puts "-----------------------------------------------------------------------------"
        puts ""
        
        win = OpenMirror::PopupGui.new(EXPORT_FILE_ERROR, @@qApp)
        win.show

      rescue Exception => exception
        puts "-----------------------------------------------------------------------------"
        puts " Erreur : " + exception.message
        puts ""
        puts exception.backtrace
        puts "-----------------------------------------------------------------------------"
        puts ""

        win = OpenMirror::PopupGui.new(EXPORT_SERIOUS_ERROR, @@qApp)
        win.show
      end
    end
    
    #Importer configuration depuis fichier
    def import()
      begin
        fname = Qt::FileDialog.getOpenFileNames(self, trUtf8(IMPORT_DIALOG_TITLE))
        
        loadEventsFromConfig(fname.first)
           
      rescue Errno::ENOENT
        puts "-----------------------------------------------------------------------------"
        puts IMPORT_FILE_ERROR
        puts ""
        puts "-----------------------------------------------------------------------------"
        puts ""
        
        win = OpenMirror::PopupGui.new(IMPORT_FILE_ERROR, @@qApp)
        win.show

      rescue Exception => exception
        puts "-----------------------------------------------------------------------------"
        puts " Erreur : " + exception.message
        puts ""
        puts exception.backtrace
        puts "-----------------------------------------------------------------------------"
        puts ""

        win = OpenMirror::PopupGui.new(IMPORT_SERIOUS_ERROR, @@qApp)
        win.show
      end
    end
    
    #Supprimer event
    def eventRemove()
      #Uniquement si une event est séléectionnée
      if(@eventList.isItemSelected(@eventList.currentItem)) then
        answer = Qt::MessageBox::question(self, trUtf8(WINDOW_TITLE), trUtf8(EVENT_REMOVE_TEXT), Qt::MessageBox::Yes, Qt::MessageBox::No)
        
        if(answer == Qt::MessageBox::Yes) then
          #indiquer que la configuration à été modifiée
          modified(true)
          
          #retirer l'event de la configuration en mémoire
          @@loadedEventsList.delete_at(@eventList.currentRow)
          
          #retirer l'event de la vue
          @eventList.takeItem(@eventList.currentRow)
          
          #mettre à jour les vues de droite
          showDetails(@eventList.currentItem)
        end
      end
    end
    
    #Supprimer match
    def matchRemove()
      #Uniquement si un match est séléectionné
      if(@eventMatchesList.isItemSelected(@eventMatchesList.currentItem)) then
        answer = Qt::MessageBox::question(self, trUtf8(WINDOW_TITLE), trUtf8(MATCH_REMOVE_TEXT), Qt::MessageBox::Yes, Qt::MessageBox::No)
        
        if(answer == Qt::MessageBox::Yes) then
          #indiquer que la configuration à été modifiée
          modified(true)
          
          #retirer le match de la configuration en mémoire
          @@loadedEventsList[@eventList.currentRow].matches.delete_at(@eventMatchesList.currentRow)
          
          #retirer l'event de la vue
          @eventMatchesList.takeItem(@eventMatchesList.currentRow)
        end
      end
    end
    
    #Supprimer action
    def actionRemove()
      #Uniquement si une action est séléectionnée
      if(@eventActionsList.isItemSelected(@eventActionsList.currentItem)) then
        answer = Qt::MessageBox::question(self, trUtf8(WINDOW_TITLE), trUtf8(ACTION_REMOVE_TEXT), Qt::MessageBox::Yes, Qt::MessageBox::No)

        if(answer == Qt::MessageBox::Yes) then
          #indiquer que la configuration à été modifiée
          modified(true)
          
          #retirer le match de la configuration en mémoire
          @@loadedEventsList[@eventList.currentRow].actions.delete_at(@eventActionsList.currentRow)
          
          #retirer l'event de la vue
          @eventActionsList.takeItem(@eventActionsList.currentRow)
        end
      end
    end
    
    
    #Ajouter un event
    def eventAdd()      
      #demander à l'utilisateur de saisir le nouveau nom
      eventName = Qt::InputDialog.getText(self, WINDOW_TITLE, EVENT_NAME_ADD)
      
      if(!eventName.nil? and !eventName.empty?)
        #indiquer que la configuration à été modifiée
        modified(true)
        
        #ajouter à la configuration en mémoire
        @@loadedEventsList << Event.new(eventName, [], [])
       
        #ajouter à la vue
        @eventList.addItem(Qt::ListWidgetItem.new(trUtf8(eventName)))
        
        #Séléctionner nouvel event
        @eventList.currentRow = @eventList.count - 1
        
        #Enchainement automatique.   
        answer = Qt::MessageBox::question(self, trUtf8(WINDOW_TITLE), trUtf8(EVENT_SEQ_MATCH_ADD), Qt::MessageBox::Yes, Qt::MessageBox::No)
        if(answer == Qt::MessageBox::Yes) then
          begin
            self.matchAdd()
            answer = Qt::MessageBox::question(self, trUtf8(WINDOW_TITLE), trUtf8(EVENT_SEQ_MATCH_ADD_AGAIN), Qt::MessageBox::Yes, Qt::MessageBox::No)
          end while answer == Qt::MessageBox::Yes
        end

        answer = Qt::MessageBox::question(self, trUtf8(WINDOW_TITLE), trUtf8(EVENT_SEQ_ACTION_ADD), Qt::MessageBox::Yes, Qt::MessageBox::No)
        if(answer == Qt::MessageBox::Yes) then
          begin
            self.actionAdd()
            answer = Qt::MessageBox::question(self, trUtf8(WINDOW_TITLE), trUtf8(EVENT_SEQ_ACTION_ADD_AGAIN), Qt::MessageBox::Yes, Qt::MessageBox::No)
          end while answer == Qt::MessageBox::Yes
        end
        
        #mettre à jour les vues de droite
        showDetails(@eventList.currentItem)
      end
    end
    
    
    #Ajouter un match
    def matchAdd()
      #Uniquement si une event est séléectionnée
      if(@eventList.isItemSelected(@eventList.currentItem)) then
                
        field = CustomDialog.new(:COMBOBOX, {:title => WINDOW_TITLE,  :text => MATCH_ADD_FIELD_TEXT, :values => MATCH_FIELDS}).value
        
        #Par défaut on réalise des saisies sur des entiers
        inputMode = INPUT_MODES[:INTEGER]
                
        availableInputModes = INPUT_MODES.clone
        availableInputModes.delete(:STRING)
        if !MATCH_VALUES_CONSTANTS.has_key? field then
          availableInputModes.delete(:CONSTANTS)
        end
   
        inputMode = CustomDialog.new(:COMBOBOX, {:title => WINDOW_TITLE,  :text => INPUT_MODE_TEXT, :values => availableInputModes.values}).value
        
        #Dialogue en fonction du mode choisi
        case(inputMode)
          when trUtf8(INPUT_MODES[:CONSTANTS])
            value = CustomDialog.new(:COMBOBOX, {:title => WINDOW_TITLE,  :text => MATCH_ADD_VALUE_TEXT, :values => MATCH_VALUES_CONSTANTS[field]}).value
            
            # Adaptation de la valeur de retour
            if !value.nil? then
              if(field == 'COMMAND') then
                value = Tag::COMMAND[value.to_sym]
              else
                value = Tag::ACTION[value.to_sym]
              end  
            end
            
          when trUtf8(INPUT_MODES[:REGEX])
            value = CustomDialog.new(:LINE_EDIT_REGEX, {:title => WINDOW_TITLE,  :text => MATCH_ADD_VALUE_TEXT}).value

            # Adaptation de la valeur de retour
            if !value.nil? then
              value = Regexp.new(value)
            end

          when trUtf8(INPUT_MODES[:INTEGER])
            value = CustomDialog.new(:LINE_EDIT, {:title => WINDOW_TITLE,  :text => MATCH_ADD_VALUE_TEXT}).value
        end
        

        if(!field.nil? and !value.nil?) then
          #Création d'un event temporaire
          newMatch = Event::Match.new(field.downcase.to_sym,value)

          #Ajouter à l'event en mémoire
          @@loadedEventsList[@eventList.currentRow].matches << newMatch
          
          #Ajouter à la vue
          @eventMatchesList.addItem(Qt::ListWidgetItem.new(trUtf8(newMatch.field.to_s + " \t=> " + newMatch.value.to_s)))
          
          #indiquer que la configuration à été modifiée
          modified(true)
        end
      end
    end    
    
    #Ajouter une action
    def actionAdd()
      #Uniquement si une event est séléctionnée
      if(@eventList.isItemSelected(@eventList.currentItem)) then
        
        newAction = nil
        type = CustomDialog.new(:COMBOBOX, {:title => WINDOW_TITLE,  :text => ACTION_ADD_FIELD_TEXT, :values => ACTION_TYPES}).value
        
        case(type)
          when 'SYSTEM_COMMAND'
            #Par défaut on réalise des saisies sur des entiers
            command = CustomDialog.new(:LINE_EDIT, {:title => WINDOW_TITLE,  :text => MATCH_ADD_VALUE_TEXT}).value
            
            if(!command.nil? and !command.empty?) then
              #création d'une action temporaire
              newAction = Action::Execute.new(command)
            end

          when 'HTTP_REQUEST'
            #Initialisation par défaut des champs
            url         = ""
            method      = :GET
            params      = {}
            headers     = {}
            data        = ""
            
            #Selectionner la méthode http
            method = CustomDialog.new(:COMBOBOX, {:title => WINDOW_TITLE,  :text => ACTION_HTTP_METHODS_TEXT, :values => Action::HTTP_URL::HTTP_METHODS.values.sort}).value
            return false if method.nil?
            
            #Saisie de l'url 
            url = CustomDialog.new(:LINE_EDIT, {:title => WINDOW_TITLE,  :text => ACTION_HTTP_URL_TEXT}).value
            return false if url.nil? or url.nil?

            # Adaptation de la valeur de retour
            url = URI.parse(url)

            #Saisie facultative des headers
            answer = Qt::MessageBox::question(self, trUtf8(WINDOW_TITLE), trUtf8(ACTION_HTTP_HEADERS_TEXT_ASK), Qt::MessageBox::Yes, Qt::MessageBox::No)
            if(answer == Qt::MessageBox::Yes) then
              begin
                field = CustomDialog.new(:LINE_EDIT, {:title => WINDOW_TITLE,  :text => ACTION_HTTP_HEADERS_TEXT_FIELD}).value
                if !field.nil? then
                  value = CustomDialog.new(:LINE_EDIT, {:title => WINDOW_TITLE,  :text => ACTION_HTTP_HEADERS_TEXT_VALUE}).value
                  if !value.nil? then
                    headers.store(field, value)
                  end
                end
              answer = Qt::MessageBox::question(self, trUtf8(WINDOW_TITLE), trUtf8(ACTION_HTTP_HEADERS_TEXT_ASK_AGAIN), Qt::MessageBox::Yes, Qt::MessageBox::No)
              end while answer == Qt::MessageBox::Yes
            end
            
            case(method)
              when 'POST', 'PUT'
              #Saisie facultative de params            
              answer = Qt::MessageBox::question(self, trUtf8(WINDOW_TITLE), trUtf8(ACTION_HTTP_PARAMS_TEXT_ASK), Qt::MessageBox::Yes, Qt::MessageBox::No)
              if(answer == Qt::MessageBox::Yes) then
                begin
                  field = CustomDialog.new(:LINE_EDIT, {:title => WINDOW_TITLE,  :text => ACTION_HTTP_PARAMS_TEXT_FIELD}).value
                  if !field.nil? then
                    value = CustomDialog.new(:LINE_EDIT, {:title => WINDOW_TITLE,  :text => ACTION_HTTP_PARAMS_TEXT_VALUE}).value
                    if !value.nil? then
                      params.store(field, value)
                    end
                  end
                  answer = Qt::MessageBox::question(self, trUtf8(WINDOW_TITLE), trUtf8(ACTION_HTTP_PARAMS_TEXT_ASK_AGAIN), Qt::MessageBox::Yes, Qt::MessageBox::No)
                end while answer == Qt::MessageBox::Yes
              end

            #Saisie facultative des data
            answer = Qt::MessageBox::question(self, trUtf8(WINDOW_TITLE), trUtf8(ACTION_HTTP_DATA_TEXT_ASK), Qt::MessageBox::Yes, Qt::MessageBox::No)
            if(answer == Qt::MessageBox::Yes) then
              value = CustomDialog.new(:LINE_EDIT, {:title => WINDOW_TITLE,  :text => ACTION_HTTP_DATA_TEXT_VALUE}).value
            end                
          end 
          
          #création d'une action temporaire
          newAction = Action::HTTP_URL.new(url, method = :GET, params = {}, headers = {}, data = "")
        end
      
          
        if(!type.nil? and !newAction.nil?) then
          #Ajouter à l'event en mémoire
          @@loadedEventsList[@eventList.currentRow].actions << newAction
          
          #Ajouter à la vue
          @eventActionsList.addItem(Qt::ListWidgetItem.new(trUtf8('[' + newAction.class.to_s.gsub("OpenMirror::Action::",'') + '] : ' + newAction.to_s )))
          
          #indiquer que la configuration à été modifiée
          modified(true)
        end
      end
    end
    
    def matchEdit()
      puts "< désolé cette fonctionnalité n'est pas encore implémentée>"
    end
    
    def actionEdit()
      puts "< désolé cette fonctionnalité n'est pas encore implémentée>"
    end
  end
end


#Ajouté fonctionnalité de swapping à la classe Array
class Array
  def swap!(x,y)
    self[x], self[y] = self[y], self[x]
    self
  end
end