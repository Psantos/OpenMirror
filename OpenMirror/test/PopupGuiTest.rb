#!/usr/bin/env ruby
# Script de test pour la classe PopupGui
#
# Author::      dos Santos Pedro  (pedro.d2.santos@gmail.com)
# Copyright::   Copyright (c) 2010 - dos Santos Pedro.
# Date::        30 juin 2010
# Version::     1.0
# Modifications:: 
# :title:       PopupGuiTest.rb
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

__GUIPATH__ = File.join($ROOTPATH, "gui","")

require __GUIPATH__ + 'PopupGui.rb'

include OpenMirror

def ok
  puts "\t OK"
end

def ko
  puts "\t KO"
  raise RuntimeError, "Une erreur s'est produite, \n Veuillez corriger et relancer le test."
end

message = "Votre fenêtre de popup fonctionne.\nElle va se fermer automatiquement.\n\nIl vous est aussi possible de la fermer\nen cliquant sur le bouton fermer"
messageLong = "Voici un exemple de message très long, sans aucun retour de chariot."

puts
puts "-------------------------------"
puts " * Scénario : Appels standard  "
puts "-------------------------------"

print " *> popup avec paramètres par défaut :"
begin
  app = Qt::Application.new(ARGV)
  win = OpenMirror::PopupGui.new(message, app, true)
  win.show
  app.exec
 ok
rescue
 ko
end

print " *> popup avec message vide  :"
begin
  app = Qt::Application.new(ARGV)
  win = OpenMirror::PopupGui.new("", app, true)
  win.show
  app.exec
  ok
rescue
  ko
end

print " *> popup avec message long :"
begin
  app = Qt::Application.new(ARGV)
  win = OpenMirror::PopupGui.new(messageLong, app, true)
  win.show
  app.exec
  ok
rescue
  ko
end

puts
puts "---------------------------------"
puts " * Scénario : Appels Paramétrés  "
puts "---------------------------------"

print " *> popup avec couleur pêche :"
begin
  app = Qt::Application.new(ARGV)
  win = OpenMirror::PopupGui.new(message, app, true, "PeachPuff")
  win.show
  app.exec
  ok
rescue
  ko
end

print " *> popup avec couleur neige et delai plus court :"
begin
  app = Qt::Application.new(ARGV)
  win = OpenMirror::PopupGui.new(message, app, true, "Snow", 1000)
  win.show
  app.exec
  ok
rescue
  ko
end

puts
puts "---------------------------------"
puts " * Scénario : Appels incorrects  "
puts "---------------------------------"

print " *> popup avec un paramètre color invalide (nil)): "
begin
  app = Qt::Application.new(ARGV)
  win = OpenMirror::PopupGui.new(message, app, true, nil)
  win.show
  app.exec
  ko
rescue
  ok
end

print " *> popup avec un paramètre closeDelaySeconds invalide (type String)): "
begin
  app = Qt::Application.new(ARGV)
  win = OpenMirror::PopupGui.new(message, app, true, "Chocolate", "5")
  win.show
  app.exec
  ko
rescue
  ok
end

print " *> popup avec un paramètre closeDelaySeconds invalide (nombre négatif)): "
begin
  app = Qt::Application.new(ARGV)
  win = OpenMirror::PopupGui.new(message, app, true, "Chocolate", -5)
  win.show
  app.exec
  ko
rescue
  ok
end

puts
puts "-----------------------------------------------"
puts " * Tous les tests ont été réussis avec succès  "
puts "-----------------------------------------------"
puts "
                           oooo$$$$$$$$$$$$oooo
                       oo$$$$$$$$$$$$$$$$$$$$$$$$o
                    oo$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$o         o$   $$ o$
    o $ oo        o$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$o       $$ $$ $$o$
 oo $ $ '$      o$$$$$$$$$    $$$$$$$$$$$$$    $$$$$$$$$o       $$$o$$o$
 '$$$$$$o$     o$$$$$$$$$      $$$$$$$$$$$      $$$$$$$$$$o    $$$$$$$$
   $$$$$$$    $$$$$$$$$$$      $$$$$$$$$$$      $$$$$$$$$$$$$$$$$$$$$$$
   $$$$$$$$$$$$$$$$$$$$$$$    $$$$$$$$$$$$$    $$$$$$$$$$$$$$  '''$$$
    '$$$''''$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     '$$$
     $$$   o$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     '$$$o
    o$$'   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$       $$$o
    $$$    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$''$$$$$$ooooo$$$$o
   o$$$oooo$$$$$  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  o$$$$$$$$$$$$$$$$$
   $$$$$$$$'$$$$   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     $$$$''''''''''''
            $$$$    '$$$$$$$$$$$$$$$$$$$$$$$$$$$$'      o$$$
             '$$$o     '''$$$$$$$$$$$$$$$$$$'$$'         $$$
               $$$o          '$$''$$$$$$''''           o$$$
                $$$$o                                o$$$'
                 '$$$$o      o$$$$$$o'$$$$o        o$$$$
                   '$$$$$oo     ''$$$$o$$$$$o   o$$$$''
                     ''$$$$$oooo  '$$$o$$$$$$$$$'''
                         ''$$$$$$$oo $$$$$$$$$$
                                 ''''$$$$$$$$$$$
                                     $$$$$$$$$$$$
                                      $$$$$$$$$$'
                                      '$$$''''
"

exit