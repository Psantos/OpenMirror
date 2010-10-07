#!/usr/bin/env ruby
# Script de test pour la classe CustomDialog
#
# Author::      dos Santos Pedro  (pedro.d2.santos@gmail.com)
# Copyright::   Copyright (c) 2010 - dos Santos Pedro.
# Date::        30 juin 2010
# Version::     1.0
# Modifications:: 
# :title:       CustomDialogest.rb
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

require __GUIPATH__ + 'CustomDialog.rb'

include OpenMirror
app = Qt::Application.new(ARGV)

def ok
  puts "\t OK"
end

def ko
  puts "\t KO"
  raise RuntimeError, "Une erreur s'est produite, \n Veuillez corriger et relancer le test."
end

puts
puts "-------------------------------"
puts " * Scénario : Appels standard  "
puts "-------------------------------"

print " *> dialogue saisie texte:"
begin

  _INPUT_REQUEST = 'Tintin'
  _INPUT_TEXT    = "Veuillez saisir: "
  _INPUT_TITLE   = "Saisie Texte"
  _INPUT_TYPE    = :LINE_EDIT
  
  input =  CustomDialog.new(_INPUT_TYPE, {:title => _INPUT_TITLE,  :text => _INPUT_TEXT + _INPUT_REQUEST}).value
  if input == _INPUT_REQUEST then
    ok
  else
    ko
  end
rescue
  ko
end


print " *> dialogue saisie regexp:"
begin
  _INPUT_REQUEST = '^$'
  _INPUT_TEXT    = "Veuillez saisir: "
  _INPUT_TITLE   = "Saisie Expression regulière"
  _INPUT_TYPE    = :LINE_EDIT_REGEX
  
  input =  CustomDialog.new(_INPUT_TYPE, {:title => _INPUT_TITLE,  :text => _INPUT_TEXT + _INPUT_REQUEST}).value
  if input == _INPUT_REQUEST then
    ok
  else
    ko
  end
rescue
  ko
end


print " *> dialogue saisie texte:"
begin
  _INPUT_REQUEST = 'DEUX'
  _INPUT_TEXT    = "Veuillez sélectionner: "
  _INPUT_TITLE   = "Selection"
  _INPUT_TYPE    = :COMBOBOX
  _INPUT_ARRAY   = ['UN', 'DEUX', 'TROIS']
  
  #demander à l'utilisateur de saisir le nouveau nom
  input =  CustomDialog.new(_INPUT_TYPE, {:title => _INPUT_TITLE,  :text => _INPUT_TEXT + _INPUT_REQUEST, :values => _INPUT_ARRAY}).value
  if input == _INPUT_REQUEST then
    ok
  else
    ko
  end
rescue
  ko
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