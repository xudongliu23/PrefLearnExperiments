#include <iostream>
#include <fstream>
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
using namespace std;

void getStatsSingle(string path, int sampleSize);

int main(int argc, char** argv) {
#if 0
	string path = argv[2];
	if(strcmp(argv[1], "acuracy") == 0) {
		getStatsSingle(path);
	}
	else if(strcmp(argv[1], "time") == 0) {
		//getAvgRunTime(path);
	}
#endif

	string path = argv[1];
	int sampleSize = atoi(argv[2]);
	getStatsSingle(path, sampleSize);


	return 0;
}

void getStatsSingle(string path, int sampleSize) {
	ifstream ifile;
	double table[2];
	for(int i=0; i<2; i++) {
		table[i] = 0.0;
	}

	//ifile.open("/home/xudong/Codes/PrefLearnExperiments_Train_Test/CarEvaluation/Results/results.txt");
	ifile.open(path.c_str());
	if(!ifile.is_open()) {cout << "Error opening file!" << endl;}
	else {
		string line;
		int userID;
		int satStringInd = 0;
		while(getline(ifile, line)) {
			string satisfyString = "Satisfy";
			size_t foundSatString = line.find(satisfyString);
			if(foundSatString != string::npos) {
				if(satStringInd == 0) {
					size_t foundLeftPar = line.find("(");
					size_t foundRightPar = line.find(")");
					table[0] += atof(line.substr(foundLeftPar+1, foundRightPar-foundLeftPar-1).c_str());

					satStringInd++;
				} else {
					size_t foundLeftPar = line.find("(");
					size_t foundRightPar = line.find(")");
					table[1] += atof(line.substr(foundLeftPar+1, foundRightPar-foundLeftPar-1).c_str());

					satStringInd = 0;
				}
			}
		}
	}
	ifile.close();

	cout << sampleSize << ",";
	//for(int i=0; i<2; i++) {
	//	cout << table[i] / 20 << ",";
	//}
	cout << table[0] / 20 << "," << table[1] / 20;
	cout << endl;

}

