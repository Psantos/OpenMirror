# Classe permettant de créer un gui global pour le projet OpenMirror
# 
# Author::      dos Santos Pedro  (pedro.d2.santos@gmail.com)
# Copyright::   Copyright (c) 2010 - dos Santos Pedro.
# Date::        17 juillet 2010
# Version::     1.0
# :title:       GlobalGui.rb
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
require __LIBPATH__ + 'Mirror.rb'
require __GUIPATH__ + 'WebAppGui.rb'
require __GUIPATH__ + 'SimulationGui.rb'
require __GUIPATH__ + 'ConfigurationGui.rb'

module OpenMirror
  class GlobalGui < Qt::Widget
    
    #Instance unique de l'application Qt
    @@qApp = nil
    
    __PATH__       = File.join(File.dirname(__FILE__),"")
    __CONFIGPATH__ = File.join($ROOTPATH, "config","")

    
    #URL application web distante
    WEB_APPLICATION_URL = "http://wiki.github.com/Psantos/OpenMirror/"
    
    #Fichier de configuration des events
    EVENT_CONFIGURATION_FILE = __CONFIGPATH__ + "events.yml"
    
    #Marges internes et externes des layout
    GLOBAL_LAYOUT_MARGIN = 15
    LAYOUT_SPACING       = 5
    LAYOUT_MARGIN        = 5

    #Taille iniale de la fenêtre
    MIN_WIDTH = 1024
    MIN_HEIGHT = 768

    #Titres et labels de l'application
    STATUS_GROUPBOX_TITLE       = "Résumé de l'environnent"
    NUM_OF_MIRRORS_LABEL        = "Nombre de mirrors détectés: "
    WEBAPP_GROUPBOX_TITLE       = "Vue sur l'application distante"
    
    GENERAL_TAB_TEXT            = "Général"
    SIMULATION_TAB_TEXT         = "Simulateur"
    CONFIGURATION_TAB_TEXT      = "Configuration"
    
    #Images de la gui
    HEADER_IMAGE_FILE_NAME = __PATH__ + "media/nanoztagHeader.png"
    
  
    #Constructeur du widget global 
    def initialize(qApp, parent = nil, eventConfiguration = EVENT_CONFIGURATION_FILE, webAppUrl = WEB_APPLICATION_URL, color = nil)
      @@qApp = qApp
      super(parent)

      @@config = eventConfiguration
      @@webAppUrl = webAppUrl
      
      #Construction du layout global
      globalLayout = Qt::VBoxLayout.new(self)
      globalLayout.spacing = LAYOUT_SPACING
      globalLayout.margin =  GLOBAL_LAYOUT_MARGIN
      setStyleSheet("background-color: #{color}") unless color.nil?
      
      #entête
      headerLayout       = Qt::HBoxLayout.new
      imageHeader        = Qt::Image.new(HEADER_IMAGE_FILE_NAME)
      headerLabel        = Qt::Label.new
      headerSpacerLeft   = Qt::SpacerItem.new(0, 0, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)
      headerSpacerRight  = Qt::SpacerItem.new(0, 0, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)
      headerLabel.pixmap = Qt::Pixmap.fromImage(imageHeader)
      headerLayout.addItem(headerSpacerLeft)
      headerLayout.addWidget(headerLabel)
      headerLayout.addItem(headerSpacerRight)
      globalLayout.addLayout(headerLayout)
      
      
      #Vue générale
      mainViewWidget = Qt::Widget.new
      mainViewLayout = Qt::VBoxLayout.new
      mainViewWidget.setLayout(mainViewLayout)
      
      #Construction de la vue principale
      mainLayout   = Qt::VBoxLayout.new
      statusLayout = Qt::HBoxLayout.new
      statusGroupBox = Qt::GroupBox.new(trUtf8(STATUS_GROUPBOX_TITLE))
      statusGroupBox.layout = statusLayout
      mainViewLayout.addWidget(statusGroupBox)

      #Affiche le nombre de mirrors connectés
      begin
        numMirrors = Qt::Label.new(trUtf8(NUM_OF_MIRRORS_LABEL + Mirror.mirrors.count.to_s))
      rescue OpenMirror::Mirror::MirrorError
        numMirrors = Qt::Label.new(trUtf8(NUM_OF_MIRRORS_LABEL + '0'))
      end
      statusLayout.addWidget(numMirrors)
      
      #Affiche une vue sur une application distante
      webAppLayout = Qt::VBoxLayout.new
      webAppGroupBox = Qt::GroupBox.new(trUtf8(WEBAPP_GROUPBOX_TITLE))
      webAppGroupBox.layout = webAppLayout
      webAppLayout.addWidget(WebAppGui.new(@@qApp, self, @@webAppUrl))
      mainViewLayout.addWidget(webAppGroupBox)
            
      #Création des différents tabs
      tabWidget = Qt::TabWidget.new
      tabWidget.addTab(mainViewWidget,                               trUtf8(GENERAL_TAB_TEXT))
      tabWidget.addTab(SimulationGui.new(@@qApp),                    trUtf8(SIMULATION_TAB_TEXT))
      tabWidget.addTab(ConfigurationGui.new(@@qApp, self, @@config), trUtf8(CONFIGURATION_TAB_TEXT))
      globalLayout.addWidget(tabWidget)

      setLayout(globalLayout)

      #Redimensionner à une taille spécifique
      resize(MIN_WIDTH, MIN_HEIGHT)
    end
  end
end
