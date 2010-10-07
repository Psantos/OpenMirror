# Classe permettant d'afficher un popup graphique Qt avec un message personnalisé
# 
# Author::      dos Santos Pedro  (pedro.d2.santos@gmail.com)
# Copyright::   Copyright (c) 2010 - dos Santos Pedro.
# Date::        30 juin 2010 
# Version::     1.0
# :title:       PopupGui.rb
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
  class PopupGui < Qt::Frame
    
    __PATH__ = File.join(File.dirname(__FILE__),"")

    #Marges du popup vis à vis du coin inférieur droit
    RIGHT_RATIO_MARGIN  = 10000
    BOTTOM_RATIO_MARGIN = 22
    
    #Marges internes et externes du layout
    LAYOUT_SPACING = 5
    LAYOUT_MARGIN = 15 

    #Taille de la fenêtre de popup
    MIN_WIDTH = 400
    MIN_HEIGHT = 200
    
    #Image du popup
    IMAGE_FILE_NAME = __PATH__ + "media/nanoztag.png"
    
    #Constantes de texte
    CLOSE_BUTTON_TEXT = "Fermer"
    
    #Délai de fermeture du popup. (milisec)
    DEFAULT_CLOSE_DELAY = 3000
    
    #Instance d'exécution de Qt
    @@qApp = nil
    
    #Constructeur du popup
    def initialize(message, qApp, alone = false, color=nil, closeDelayMilliSeconds = DEFAULT_CLOSE_DELAY)
      
      #Constructeur parent avec paramètres pour popup
      super(nil, Qt::X11BypassWindowManagerHint | Qt::WindowStaysOnTopHint | Qt::Tool | Qt::FramelessWindowHint)
      
      #Vérification de la validité des paramètres
      raise ArgumentError, "#{message.class} invalide, Tag requis", caller unless message.is_a? String 
      raise ArgumentError, "#{qApp.class} invalide, Qt::Application requis", caller unless qApp.is_a? Qt::Application 
      raise ArgumentError, "#{color.class} invalide, String requis", caller unless color.is_a? String or color.nil?
      raise ArgumentError, "#{closeDelayMilliSeconds.class} invalide, Fixnum requis", caller unless closeDelayMilliSeconds.is_a? Fixnum and closeDelayMilliSeconds > 0
      
      @@qApp = qApp
      @infoMessage = Qt::Translator::trUtf8(message)
      @closeDelay = closeDelayMilliSeconds
      @alone = alone
      
      #Paramètres du cadre
      setFrameStyle(Qt::Frame::StyledPanel | Qt::Frame::Raised)
      setStyleSheet("background-color: #{color}") unless color.nil?
      setMinimumWidth(MIN_WIDTH)
      setMinimumHeight(MIN_HEIGHT)
      
      #Paramètres du layout global
      globalLayout = Qt::HBoxLayout.new(self)
      globalLayout.spacing = LAYOUT_SPACING
      globalLayout.margin = LAYOUT_MARGIN

      #Configuration du label contenant l'image
      printer = Qt::Printer.new
      imageLabel = Qt::Label.new
      imageLabel.backgroundRole = Qt::Palette::Base
      imageLabel.setSizePolicy(Qt::SizePolicy::Maximum, Qt::SizePolicy::Maximum)
      imageLabel.scaledContents = true

      #Ajouter une image au popup si celle-ci est valide
      image = Qt::Image.new(IMAGE_FILE_NAME)
      if(image.nil?)
        #Popup sans image
        imageLabel.text = "OpenMirror"
        imageLabel.setStyleSheet("font-weight: bold;" +
                                 "font-variant: small-caps;")
      else
        #Popup avec image
        imageLabel.pixmap = Qt::Pixmap.fromImage(image)
      end

      #Construction d'un layout avec les informations
      infoLayout = Qt::VBoxLayout.new()
      infoLayout.spacing = LAYOUT_SPACING
      infoLayout.margin = LAYOUT_MARGIN

      #Construction d'un label avec les informations
      infolabel = Qt::Label.new(@infoMessage, self)

      #Bouton Quitter
      quitButton = Qt::PushButton.new(trUtf8(CLOSE_BUTTON_TEXT), self)

      #Construction de la vue    
      globalLayout.addWidget(imageLabel)
      globalLayout.addLayout(infoLayout)
      
      infoLayout.addWidget(infolabel)
      infoLayout.addWidget(quitButton)
      
      #Connexions
      Qt::Object.connect(quitButton, SIGNAL('clicked()'), self, SLOT('hide()'))
    end

    #Afficher le popup
    def show
      super
      
      #Déplacer le cadre en bas à droite
      screen_width  = Qt::Application.desktop().width()
      screen_height =  Qt::Application.desktop().height()
      move(screen_width - width() - (screen_width / RIGHT_RATIO_MARGIN), Qt::Application.desktop().height() - height() - (screen_height / BOTTOM_RATIO_MARGIN))
      
      #Démarrer un timer de fermeture automatique
      timer = Qt::Timer.new(self)
      if @alone then
        Qt::Object.connect(timer, SIGNAL('timeout()'), @@qApp, SLOT('quit()'))
      else
        Qt::Object.connect(timer, SIGNAL('timeout()'), self, SLOT('hide()'))
      end
      timer.start(@closeDelay)
    end
  end
end