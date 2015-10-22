#include <iostream>
#include <fstream>
#include <string>
#include <stdio.h>
#include <stdlib.h>
using namespace std;

void getStatsSingle();
void getStatsMultiple(int number_of_iterations);

int main(int argc, char** argv) {
	string number_of_iterations_string = string(argv[1]);

	if(number_of_iterations_string == "1") {
		getStatsSingle();
	}
	else {
		getStatsMultiple(atoi(number_of_iterations_string.c_str()));
	}


	return 0;
}

void getStatsSingle() {
	ifstream ifile;

	ifile.open("/home/xudong/Codes/PrefLearnExperiments/Cars2/Results/results.txt");
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
}

void getStatsMultiple(int number_of_iterations) {
	ifstream ifile;
	double table[60][6];
	for(int i=0; i<60; i++) {
		for(int j=0; j<6; j++) {
			table[i][j] = 0.0;
		}
	}

	ifile.open("/home/xudong/Codes/PrefLearnExperiments/Cars2/Results/results.txt");
	if(!ifile.is_open()) {cout << "Error opening file!" << endl;}
	else {
		string line;
		int userID;
		int iterationID;
		bool firstSatString = false;
		while(getline(ifile, line)) {
			string maxLearnString = "MaxLearn";
			string satisfyString = "Satisfy";
			size_t foundMaxLearnString = line.find(maxLearnString);
			size_t foundSatString = line.find(satisfyString);
			if(foundMaxLearnString != string::npos) {
				size_t foundUserString = line.find("user");
				size_t foundIterationString = line.find("iteration");
				userID = atoi(line.substr(foundUserString+5, foundIterationString-foundUserString-6).c_str());
				size_t foundLastSpace = line.find_last_of(" ");
				size_t foundColon = line.find_last_of(":");
				iterationID = atoi(line.substr(foundLastSpace+1,foundColon-foundLastSpace-1).c_str());
			}
			else if(foundSatString != string::npos) {
				if(firstSatString == false) {
					size_t foundFirstSpace = line.find(" ");
					size_t foundOutString = line.find("out");
					table[userID][0] += atoi(line.substr(foundFirstSpace+1, foundOutString-foundFirstSpace-2).c_str());
					size_t foundOf = line.find("of");
					size_t foundLeftPar = line.find("(");
					table[userID][1] += atoi(line.substr(foundOf+3, foundLeftPar-foundOf-4).c_str());
					size_t foundRightPar = line.find(")");
					table[userID][2] += atof(line.substr(foundLeftPar+1, foundRightPar-foundLeftPar-1).c_str());

					firstSatString = true;
				}
				else {
					size_t foundFirstSpace = line.find(" ");
					size_t foundOutString = line.find("out");
					table[userID][3] += atoi(line.substr(foundFirstSpace+1, foundOutString-foundFirstSpace-2).c_str());
					size_t foundOf = line.find("of");
					size_t foundLeftPar = line.find("(");
					table[userID][4] += atoi(line.substr(foundOf+3, foundLeftPar-foundOf-4).c_str());
					size_t foundRightPar = line.find(")");
					table[userID][5] += atof(line.substr(foundLeftPar+1, foundRightPar-foundLeftPar-1).c_str());

					firstSatString = false;
				}
			}
		}
	}
	ifile.close();

	for(int i=0; i<60; i++) {
		cout << i+1 << ",";
		cout << table[i][0]/number_of_iterations << "," << table[i][1]/number_of_iterations << ","
				 << table[i][2]/number_of_iterations << "," << table[i][3]/number_of_iterations << ","
				 << table[i][4]/number_of_iterations << "," << table[i][5]/number_of_iterations << endl;
	}
}


