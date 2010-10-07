# Classe permettant de créer un gui de visualisation d'un site web
# 
# Author::      dos Santos Pedro  (pedro.d2.santos@gmail.com)
# Copyright::   Copyright (c) 2010 - dos Santos Pedro.
# Date::        17 juillet 2010
# Version::     1.0
# :title:       WebAppGui.rb
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

require 'Qt'
require 'qtwebkit'
require __LIBPATH__ + 'Action.rb'
require __LIBPATH__ + 'Tag.rb'

module OpenMirror
  class WebAppGui < Qt::Widget
    
    #Instance unique de l'application Qt
    @@qApp = nil
    
    __PATH__ = File.join(File.dirname(__FILE__),"")
    
    #URL application web distante
    URL = "http://github.com/Psantos/OpenMirror/network"

    #Marges internes et externes des layout
    GLOBAL_LAYOUT_MARGIN = 15
    LAYOUT_SPACING       = 5
    LAYOUT_MARGIN        = 5

    #Taille iniale de la fenêtre
    MIN_WIDTH = 1024
    MIN_HEIGHT = 768

    #Constructeur du widget global 
    def initialize(qApp, parent = nil, urlWebApp = URL, color = nil)
      @@qApp = qApp
      super(parent)
      
      @@urlWebApp = urlWebApp
    
      #Construction du layout global
      globalLayout = Qt::HBoxLayout.new(self)
      globalLayout.spacing = LAYOUT_SPACING
      globalLayout.margin =  GLOBAL_LAYOUT_MARGIN
      setStyleSheet("background-color: #{color}") unless color.nil?
            
      #Création de l'url
      url = Qt::Url.new(@@urlWebApp)

      #Chargement de la page web
      browser = Qt::WebView.new()
      browser.load(url)
      
      # Mise en forme de la vue principale
      setLayout(globalLayout)
      globalLayout.addWidget(browser)
       
      #Redimensionner à une taille spécifique
      resize(MIN_WIDTH, MIN_HEIGHT)
    end
  end
end
