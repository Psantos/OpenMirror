//  Programme permettant d'encapsuler l'exécution d'un script dans un programme, dans le but de l'exécuter avec des droits SUID.
//  
//  Author:    		dos Santos Pedro  (pedro.d2.santos@gmail.com)
//  Copyright: 		Copyright (c) 2010 - dos Santos Pedro.
//  Date: 		15 juin 2010
//  Version:		1.0
//  Title: 		main.cpp
// -----------------------------------------------------------------------------------------------------------
// 
//    Copyright (C) 2010 dos Santos Pedro
//  
//    This file is part of OpenMirror.
//  
//    OpenMirror is free software: you can redistribute it and/or modify
//    it under the terms of the GNU Lesser General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//  
//    OpenMirror is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU Lesser General Public License for more details.
//  
//    You should have received a copy of the GNU Lesser General Public License
//    along with OpenMirror.  If not, see <http://www.gnu.org/licenses/>.
// 
// -----------------------------------------------------------------------------------------------------------


#include <iostream>
#include <stdlib.h>
using namespace std;

int main(int argc, char *argv[])
{
    if(argc != 3)
    {

        cout
        << "--------------------------------------------------------------" << endl
        << "\t usage: " << endl
        << "\t wrapperSUID <INTERPRETEUR> <SCRIPT>" << endl
        << "\t exemple: ./wrapperSUID ruby monScript.rb" << endl << endl
        << "--------------------------------------------------------------";
    }
    else
    {
        string interpreter  = argv[1];
        string script       = argv[2];
        string space        = " ";
        string outputMsg    = "echo -n '  >> as ' && whoami && echo '------------------------------'";
        int returnValue;

        // composition de la commande
        string command = interpreter + space + script;

        // affichage console
        cout << command << endl;
        returnValue = system(outputMsg.c_str());

        // exécution de la commande
        return system(command.c_str());
        return 0;
    }
}
