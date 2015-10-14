#include <iostream>
#include <fstream>
#include <string>
#include <stdio.h>
#include <stdlib.h>
using namespace std;

int main() {
	ifstream ifile;

	ifile.open("/home/xudong/Codes/PrefLearnExperiments_Train_Test/Cars2/Results/results.txt");
	if(!ifile.is_open()) {cout << "Error opening file!" << endl;}
	else {
		string line;
		int userID;
		bool firstSatString = false;
		while(getline(ifile, line)) {
			string maxLearnString = "MaxLearn";
			string satisfyString = "Satisfy";
			size_t foundMaxLearnString = line.find(maxLearnString);
			size_t foundSatString = line.find(satisfyString);
			if(foundMaxLearnString != string::npos) {
				size_t foundLastSpace = line.find_last_of(" ");
				size_t foundColon = line.find_last_of(":");
				userID = atoi(line.substr(foundLastSpace+1,foundColon-foundLastSpace-1).c_str());
				cout << userID + 1 << ",";
			}
			else if(foundSatString != string::npos) {
				if(firstSatString == false) {
					size_t foundFirstSpace = line.find(" ");
					size_t foundOutString = line.find("out");
					cout << line.substr(foundFirstSpace+1, foundOutString-foundFirstSpace-2) << ",";
					size_t foundOf = line.find("of");
					size_t foundLeftPar = line.find("(");
					cout << line.substr(foundOf+3, foundLeftPar-foundOf-4) << ",";
					size_t foundRightPar = line.find(")");
					cout << line.substr(foundLeftPar+1, foundRightPar-foundLeftPar-1) << ",";

					firstSatString = true;
				}
				else {
					size_t foundFirstSpace = line.find(" ");
					size_t foundOutString = line.find("out");
					cout << line.substr(foundFirstSpace+1, foundOutString-foundFirstSpace-2) << ",";
					size_t foundOf = line.find("of");
					size_t foundLeftPar = line.find("(");
					cout << line.substr(foundOf+3, foundLeftPar-foundOf-4) << ",";
					size_t foundRightPar = line.find(")");
					cout << line.substr(foundLeftPar+1, foundRightPar-foundLeftPar-1) << endl;

					firstSatString = false;
				}
			}
		}
	}
	ifile.close();

	return 0;
}
