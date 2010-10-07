# Classe permettant d'afficher un dialogue Qt personnalisé 
# 
# Author::      dos Santos Pedro  (pedro.d2.santos@gmail.com)
# Copyright::   Copyright (c) 2010 - dos Santos Pedro.
# Date::        8 juillet 2010 
# Version::     1.0
# :title:       CustomDialog.rb
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

require 'Qt4'

module OpenMirror
  class CustomDialog < Qt::Dialog

    __PATH__ = File.join(File.dirname(__FILE__),"")

    
    #Image du dialog
    CUSTOM_DIALOG_IMAGE = __PATH__ + "media/dialogQuestion.png"
    
    #Marges et espacement du layout principal du dialogue
    GLOBAL_LAYOUT_MARGIN  = 20
    GLOBAL_LAYOUT_SPACING = 20
    
    
    #Symboles délimitant la regEx
    REG_EX_CHAR_LEFT    =  '/'
    REG_EX_CHAR_RIGHT   =  '/'
     
    #Types de dialogues existants
    DIALOG_TYPES =  [
                      :LINE_EDIT,
                      :COMBOBOX,
                      :LINE_EDIT_REGEX,
                    ]
    
    OK_BUTTON_TEXT      = "&Ok"
    CANCEL_BUTTON_TEXT  = "&Annuler"
    
    DEFAULT_REGEX_LINEEDIT_BACKGROUND_COLOR       = 'white'
    DEFAULT_REGEX_LINEEDIT_ERROR_BACKGROUND_COLOR = 'red'
    
    slots 'valueChanged(const QString&)',
          'checkRegexp(const QString&)'
    
    #Constructeur
    #l'argument params est un Hash pouvant contenir les éléments suivants
    # - :title => Titre du dialog
    # - :text => Texte du dialogue
    # - :defaultValue => valeur initiale du champ de saisie
    # - :values => Array des valeurs des éléments à choix multiples
    def initialize(type, params)
      super()
      
      raise ArgumentError, "type   #{type} inconnu", caller unless DIALOG_TYPES.include? type
      raise ArgumentError, "params #{params.class} doit être de type Hash", caller unless params.is_a? Hash
      @returnValue = nil
      
      #Création des layouts du dialogue
      globalLayout      = Qt::VBoxLayout.new      
      inputLayout       = Qt::HBoxLayout.new
      inputInterLayout  = Qt::VBoxLayout.new
      inputTitleLayout  = Qt::HBoxLayout.new
      inputCustomLayout = Qt::HBoxLayout.new
      buttonsLayout     = Qt::HBoxLayout.new
      
      #Création des icones
      imageQuestion = Qt::Image.new(CUSTOM_DIALOG_IMAGE)
      
      #Récupération des icones inclus dans Qt
      style =  Qt::Application::style.new()
      iconOk= style.standardIcon(Qt::Style::PM_DialogButtonsButtonWidth)
      iconCancel= style.standardIcon(Qt::Style::PM_ExclusiveIndicatorWidth)
      
      #Création du label image
      imageLabel = Qt::Label.new
      imageLabel.pixmap = Qt::Pixmap.fromImage(imageQuestion)
      
      imageLabel.backgroundRole = Qt::Palette::Base
      imageLabel.setSizePolicy(Qt::SizePolicy::Maximum, Qt::SizePolicy::Maximum)

      #Création des boutons
      @okButton = Qt::PushButton.new(iconOk, OK_BUTTON_TEXT)
      @okButton.setAutoDefault(true)
      @okButton.setDefault(true)
      @okButton.setSizePolicy(Qt::SizePolicy::Maximum, Qt::SizePolicy::Maximum)
      
      @cancelButton = Qt::PushButton.new(iconCancel, CANCEL_BUTTON_TEXT)
      @cancelButton.setSizePolicy(Qt::SizePolicy::Maximum, Qt::SizePolicy::Maximum)
      
      #Création des spacers
      buttonSpacerRight = Qt::SpacerItem.new(20, 40, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)
      buttonSpacerLeft  = Qt::SpacerItem.new(20, 40, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

      #Construction du dialogue
      globalLayout.setMargin(GLOBAL_LAYOUT_MARGIN)
      globalLayout.setSpacing(GLOBAL_LAYOUT_SPACING)
      globalLayout.addLayout(inputLayout)
      globalLayout.addLayout(buttonsLayout)
      
      inputLayout.addWidget(imageLabel)
      inputLayout.addLayout(inputInterLayout)
      
      inputInterLayout.addLayout(inputTitleLayout)
      inputInterLayout.addLayout(inputCustomLayout)

      buttonsLayout.addItem(buttonSpacerLeft)
      buttonsLayout.addWidget(@okButton)
      buttonsLayout.addWidget(@cancelButton)
      buttonsLayout.addItem(buttonSpacerRight)
     
      setLayout(globalLayout) 
   
      
      #Customisation du dialogue
      
      setWindowTitle(trUtf8(params[:title])) if params[:title]
      
      titleLabel = Qt::Label.new(trUtf8(params[:text]))
      inputTitleLayout.addWidget(titleLabel)
  
      #valeur de retour = valeur par défaut si saisie
      @returnValue = trUtf8(params[:defaultValue])
      
      case type
        when :LINE_EDIT
          #Création d'un Line edit 
          lineEdit = Qt::LineEdit.new()
          lineEdit.text = trUtf8(params[:defaultValue])
          inputCustomLayout.addWidget(lineEdit)
          
          connect(lineEdit, SIGNAL("textChanged(const QString&)"), self, SLOT('valueChanged(const QString&)'))
        
        when :LINE_EDIT_REGEX
          #Création d'un Line edit et de labels décoratifs
          @lineEditRegEx = Qt::LineEdit.new()
          regExCharLeft = Qt::Label.new(REG_EX_CHAR_LEFT)
          regExCharLeft.setSizePolicy(Qt::SizePolicy::Maximum, Qt::SizePolicy::Maximum)
          regExCharRight = Qt::Label.new(REG_EX_CHAR_RIGHT)
          regExCharRight.setSizePolicy(Qt::SizePolicy::Maximum, Qt::SizePolicy::Maximum)
          
          @lineEditRegEx.text = trUtf8(params[:defaultValue])
          
          inputCustomLayout.addWidget(regExCharLeft)
          inputCustomLayout.addWidget(@lineEditRegEx)
          inputCustomLayout.addWidget(regExCharRight)
          
          connect(@lineEditRegEx, SIGNAL("textChanged(const QString&)"), self, SLOT('valueChanged(const QString&)'))
          connect(@lineEditRegEx, SIGNAL("textChanged(const QString&)"), self, SLOT('checkRegexp(const QString&)'))
          
        when :COMBOBOX
          comboBox = Qt::ComboBox.new
          if !params[:values].nil? then
  
            i = 0
            params[:values].each do |item|
               comboBox.insertItem(i, trUtf8(item))
               i += 1
            end
            
            if params[:defaultValue].is_a? Integer then
              comboBox.currentIndex = trUtf8(params[:defaultValue])
              #mise à jour de la valeur par défaut de retour
              @returnValue = trUtf8(params[:values][params[:defaultValue]])
            else
              @returnValue = trUtf8(params[:values].first)
            end
          end
          
          inputCustomLayout.addWidget(comboBox)
        
          connect(comboBox, SIGNAL("currentIndexChanged(const QString&)"), self, SLOT('valueChanged(const QString&)'))
      end
      
      #empecher le redimensionnement
      self.layout.setSizeConstraint( Qt::Layout::SetFixedSize )      
      
      #Connexion des boutons ok et annuler
      connect( @okButton, SIGNAL('clicked()'), self, SLOT('accept()') )
      connect( @cancelButton, SIGNAL('clicked()'), self, SLOT('reject()') )
      
      #afficher le dialogue
      exec
    end
    
    #Retourne la valeur saisie ou sélectionnée par l'utilisateur
    def value      
      return @returnValue
    end
    
    private 
    
    #Redéfinission de la méthode exec pour intercepter la fermeture du dialiogue
    def exec
      val = super()
      
      if val == Qt::Dialog::Accepted
        return true
      else
        @returnValue = nil
        return false
      end
    end
    
    #modifie la valeur interne de retour
    def valueChanged(value)
      @returnValue = value
    end
    
    #verifie si une regexp est valide
    def checkRegexp(value)      
      begin
        Regexp.new(value)
        
        #Regexp valid
        @okButton.enabled = true
        setStyleSheet("QLineEdit { background-color: #{DEFAULT_REGEX_LINEEDIT_BACKGROUND_COLOR} }")
      rescue
        
        #Regexp invalide
        @okButton.enabled = false
        setStyleSheet("QLineEdit { background-color: #{DEFAULT_REGEX_LINEEDIT_ERROR_BACKGROUND_COLOR} }")
      end
    end
  end
end