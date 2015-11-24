/*
 * Author: Xudong Liu
 * Last modified date: 03/20/2015
 *
 * This program does two things, depending on what set of arguments it takes.
 * If it takes 3 extra arguments: description file path, items file path and preferences file path,
 * it computes the domain of all issues, outcomes represented as their indices in the space of outcomes,
 * and pairwise preferences based on the aforementioned outcome representation.
 * If it takes 4 extra arguments: description file path, results file (for a particular user) path,
 * id of this user, and the dir of the examples.gringo file for this user,
 * it computes the human readable UI-UP PLP-tree together with accuracy.
 */

#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <utility>
#include <sstream>
#include <algorithm>

using namespace std;

typedef vector<string> vs;
typedef vector<vector<string> > vvs;
typedef pair<string,vs> pIssDom;
typedef vector<pIssDom> vpIssDom;
typedef vector<int> vi;
typedef long long ll;
typedef vector<ll> vll;

#define REP(i,a,b) \
	for(int i=(int)a; i<=(int)b; i++)

#define MAX 20480

vpIssDom getDomains(string description_path);  // get domain info for all issues from the description file
void displayDomains(vpIssDom &domains);
vs getNumericOutcomes(string items_path, vpIssDom &domains);  // get outcomes represented as strings of numeric values
string getValIndInDom(string val, int issue_ind, vpIssDom &domains); // get a numeric value of a string value in a domain
void displayNumericOutcomes(vs &numeric_outcomes);
vll getOutcomeIndices(vs numeric_outcomes, vpIssDom &domains);  // get outcomes represented as indices in the space of outcomes
																																// if outcomes_indices[i]=j, it means outcome i in the original
																																// dataset is outcome j in the space of outcomes.
ll getOutcomeInd(string numeric_outcome, vpIssDom &domains);
vs getVSOfNumericOutcome(string numeric_outcome);
void displayOutcomesIndices(vll &outcomes_indices);
void updatePrefs(string prefs_path, vll &outcomes_indices);  // update pairwise preferences using new outcome indices
ll getOutcomeInd(size_t itemId, vll &outcomes_indices);  // map original itemId to outcome index


vs getTree(string res_path, vpIssDom &domains);
int getNumberOfFalsifiedEx(string res_path);

void printOutcomes(string outcomes_path, vs numeric_outcomes, vll outcomes_indices);

int main(int argc, char** argv) {
	if(argc == 6) {  
		/* translate the pairwise preferences using the new outcome representations. */

		// get domains
		string description_path = string(argv[2]);
		vpIssDom domains = getDomains(description_path);
	
		string items_path = string(argv[3]);
		vs numeric_outcomes = getNumericOutcomes(items_path, domains);

		// get outcomes represented as single numbers
		vll outcomes_indices = getOutcomeIndices(numeric_outcomes, domains);
	
		string prefs_path = string(argv[4]);
		updatePrefs(prefs_path, outcomes_indices);

		// get outcomes for ASP
		string outcomes_path = string (argv[5]);
		printOutcomes(outcomes_path, numeric_outcomes, outcomes_indices);
	}
	else if(argc == 8) {  
		/* Gather the preference learning results, and translate them to readable formats.*/

		// get domains
		string description_path = string(argv[2]);
		vpIssDom domains = getDomains(description_path);

		string res_path = string(argv[3]);
		vs res = getTree(res_path, domains);
		//displayVS(res);
	
		string userID = string(argv[4]);
		string doubleID1 = string(argv[5]);
		string doubleID2 = string(argv[6]);
		string numberOfStrictExDir = string(argv[7]);
		string comm = "";
		if(doubleID1 == "-1" && doubleID2 == "-1") {  // user has only one training dataset.
			comm = "wc -l " + numberOfStrictExDir + "/User" + userID 
														 + "/Training/examples.gringo | awk '{print $1}'";
		}
		else if(doubleID1 == "-1") {  // user has multiple training datasets indicated by doubleID2.
			comm = "wc -l " + numberOfStrictExDir + "/User" + userID + "/Training/examples" 
														 + doubleID2 + ".gringo | awk '{print $1}'";
		}
		else {  // user has multiple training datasets indicated by doubleID1 and doubleID2.
			comm = "wc -l " + numberOfStrictExDir + "/User" + userID + "/Training/examples" 
														 + doubleID1 + doubleID2 + ".gringo | awk '{print $1}'";
		}
		FILE *fp;
		char content[8];
		fp = popen(comm.c_str(), "r");
		if(fp == NULL) {cout << "Error popen." << endl; exit(1);}
		fgets(content, 8, fp);
		pclose(fp);
		int number_of_strict_ex = atoi(content);
		int num = number_of_strict_ex - getNumberOfFalsifiedEx(res_path);
		cout << "Satisfy " << num << " out of " << number_of_strict_ex << " (" << (double)num/number_of_strict_ex 
				 << ") examples." << endl;
	}
	else {
		cout << "Wrong number of arguments.\nSystem aborted!" << endl;
	}

	return 0;
}

vpIssDom getDomains(string description_path) {
	ifstream ifile;
	vpIssDom domains;

	ifile.open(description_path.c_str());
	if(!ifile.is_open()) {cout << "Error opening file!" << endl;}
	else {
		string line;
		while(getline(ifile, line)) {
			size_t found_colon = line.find(":");
			string issue = line.substr(0,found_colon);
			vs dom;
			size_t found_comma = line.find(",");
			string val;
			size_t start = found_colon+1;
			while(found_comma != string::npos) {
				val = line.substr(start, found_comma-start);
				dom.push_back(val);
				start = found_comma+1;
				found_comma = line.find(",", start);
			}
			dom.push_back(line.substr(start));  // get the last value
			domains.push_back(make_pair(issue, dom));
		}
	}
	ifile.close();

	return domains;
}

void displayDomains(vpIssDom &domains) {
	REP(i, 0, domains.size()-1) {
		cout << "Issue " << i << " (" << domains[i].first << "):" << endl;
		REP(j, 0, domains[i].second.size()-1) {
			cout << domains[i].second.at(j) << " ";
		}
		cout << endl;
	}
}

vs getNumericOutcomes(string items_path, vpIssDom &domains) {
	ifstream ifile;
	vs numeric_outcomes;

	ifile.open(items_path.c_str());
	if(!ifile.is_open()) {cout << "Error opening file!" << endl;}
	else {
		int line_ind = 0;
		string line;
		while(getline(ifile, line)) {
			if(line_ind == 0) {
				numeric_outcomes.push_back("");
			}
			else {
				string numeric_outcome = "";
				size_t found_first_comma = line.find(",");
				size_t start = found_first_comma+1;
				size_t found_next_comma = line.find(",", start);
				int issue_ind = 0;
				while(found_next_comma != string::npos) {
					string val = line.substr(start, found_next_comma-start);
					numeric_outcome += getValIndInDom(val, issue_ind, domains)+",";
					start = found_next_comma+1;
					found_next_comma = line.find(",", start);
					issue_ind++;
				}
				numeric_outcome += getValIndInDom(line.substr(start), issue_ind, domains)+",";  // get the last value
				numeric_outcomes.push_back(numeric_outcome);
			}
			line_ind++;
		}
	}
	ifile.close();

	return numeric_outcomes;
}

string getValIndInDom(string val, int issue_ind, vpIssDom &domains) {
	int valInd = -1;

	REP(i, 0, domains[issue_ind].second.size()-1) {
		if(domains[issue_ind].second.at(i) == val) {
			valInd = i;
		}
	}

	if(valInd == -1) {
		cout << "Value " << val << " is not found in domain of issue " << domains[issue_ind].first << endl;
		exit(1);
	}

	stringstream ss;
	ss << valInd;
	return ss.str();
}

void displayNumericOutcomes(vs &numeric_outcomes) {
	REP(i, 0, numeric_outcomes.size()-1) {
		cout << numeric_outcomes[i] << endl;
	}
}

vll getOutcomeIndices(vs numeric_outcomes, vpIssDom &domains) {
	vll res;
	REP(i, 0, numeric_outcomes.size()-1) {
		if(numeric_outcomes[i] == "") {
			res.push_back(-1);
		}
		else {
			res.push_back(getOutcomeInd(numeric_outcomes[i], domains));
		}
	}

	return res;
}

ll getOutcomeInd(string numeric_outcome, vpIssDom &domains) {
	vs NO = getVSOfNumericOutcome(numeric_outcome);
	if(NO.size() > domains.size()){
		cout << "Too many values!" << endl;
		exit(1);
  }

	ll sum = 0;
	REP(i, 0, NO.size()-1){
		int digit = atoi(NO[i].c_str());
		long weight = 1;
		REP(j, i+1, domains.size()-1) {
			weight *= domains[j].second.size();
		}
		sum += digit * weight;
	}

	return sum;
}

vs getVSOfNumericOutcome(string numeric_outcome) {
	vs res;
	// The delimiter is comma
	stringstream input_stream (numeric_outcome);
	string cell_value;
	while ( getline (input_stream, cell_value, ',') ){
		res.push_back(cell_value);
	}
	return res;
}

void displayOutcomesIndices(vll &outcomes_indices) {
	REP(i, 0, outcomes_indices.size()-1) {
		cout << outcomes_indices[i] << endl;
	}
}

void updatePrefs(string prefs_path, vll &outcomes_indices) {
	ifstream ifile;

	ifile.open(prefs_path.c_str());
	if(!ifile.is_open()) {cout << "Error opening file!" << endl;}
	else {
		int line_ind = 0;
		string line;
		while(getline(ifile, line)) {
			if(line_ind == 0) {
				cout << line << endl;
			}
			else {
				size_t found_first_comma = line.find(",");
				cout << line.substr(0, found_first_comma+1);
				size_t start = found_first_comma+1;
				size_t found_next_comma = line.find(",", start);
				int issue_ind = 0;
				size_t itemId = 0;
				while(found_next_comma != string::npos) {
					itemId = (unsigned)atoi(line.substr(start, found_next_comma-start).c_str());
					cout << getOutcomeInd(itemId, outcomes_indices) << ",";
					start = found_next_comma+1;
					found_next_comma = line.find(",", start);
					issue_ind++;
				}
				itemId = (unsigned)atoi(line.substr(start).c_str());
				cout << getOutcomeInd(itemId, outcomes_indices) << endl;
			}
			line_ind++;
		}
	}
	ifile.close();
}

ll getOutcomeInd(size_t itemId, vll &outcomes_indices) {
	///////////////// Change /////////////////////////////
	//return outcomes_indices[itemId];
	return itemId;
	///////////////// Change /////////////////////////////
}

vs getTree(string res_path, vpIssDom &domains) {
	vs res;
	vs res_hr;

	string comm = "";
	comm += "grep -B 2 OPTIMUM " + res_path +" | sed -n 1p";

	FILE *fp;
	char content[MAX];
	fp = popen(comm.c_str(), "r");
	if(fp == NULL) {cout << "Error popen." << endl; exit(1);}
	fgets(content, MAX, fp);
	pclose(fp);

	char* p = content;
	string str = "";
	while(*p != '\0') {
		if(*p != ' ' && *p != ')') {
			stringstream ss;
			string tmp;
			ss << *p; ss >> tmp;
			str += tmp;
		}
		else if(*p == ' ') {
			// do nothing
		}
		else {
			res.push_back(str+")"); str="";
		}
		p++;
	}
	sort(res.begin(), res.end());

	//REP(i,0,res.size()-1) {
	//	cout << res[i] << endl;
	//}

	string issuePref = "";
	size_t count = 0;
	REP(i,0,res.size()-1) {
		// res[i] is like label(0,3,0,0)
		size_t foundLP = res[i].find("(");
		size_t foundComma1 = res[i].find(",");
		string issue_rank = res[i].substr(foundLP+1,foundComma1-foundLP-1);
		if(count == 0) {issuePref = issuePref + issue_rank + ".";}
		size_t foundComma2 = res[i].find(",", foundComma1+1);
		string issueInd = res[i].substr(foundComma1+1, foundComma2-foundComma1-1);
		if(count == 0) {issuePref = issuePref + domains[atoi(issueInd.c_str())].first + ": ";}
		size_t foundComma3 = res[i].find(",", foundComma2+1);
		string posVal = res[i].substr(foundComma2+1, foundComma3-foundComma2-1);
		size_t foundRP = res[i].find(")");
		string val = res[i].substr(foundComma3+1, foundRP-foundComma3-1);
		issuePref = issuePref + domains[atoi(issueInd.c_str())].second.at(atoi(val.c_str())) + " ";
		count++;
		if(count == domains[atoi(issueInd.c_str())].second.size()) {
			res_hr.push_back(issuePref);
			issuePref = "";
			count = 0;
		}
	}

	REP(i,0,res_hr.size()-1) {
		cout << res_hr[i] << endl;
	}

	return res_hr;
}

int getNumberOfFalsifiedEx(string res_path) {
	string comm = "";
	comm += "grep -B 2 OPTIMUM " + res_path +" | sed -n 2p";

	FILE *fp;
	char content[32];
	fp = popen(comm.c_str(), "r");
	if(fp == NULL) {cout << "Error popen." << endl; exit(1);}
	fgets(content, 32, fp);
	pclose(fp);

	string str = string(content);
	size_t foundFirstSpace = str.find(" ");
	size_t foundLastSpace = str.find_last_of(" ");

	return atoi(str.substr(foundFirstSpace+1, foundLastSpace-foundFirstSpace-1).c_str());
}

void printOutcomes(string outcomes_path, vs numeric_outcomes, vll outcomes_indices) {
	ofstream ofile;

	ofile.open(outcomes_path.c_str());
	if(!ofile.is_open()) {cout << "Error opening file!" << endl;}
	else {
		vvs NOs;
		REP(i,0,numeric_outcomes.size()-1) {
			NOs.push_back(getVSOfNumericOutcome(numeric_outcomes[i]));
		}
		// the size of NOs should be the same as the size of outcomes_indices
		REP(i,0,NOs.size()-1) {
			REP(j,0,NOs[i].size()-1) {
				ofile << "outcome(";
	///////////////// Change /////////////////////////////
				//ofile << outcomes_indices[i] << ",";
				ofile << i << ",";
	///////////////// Change /////////////////////////////
				ofile << j << "," << NOs[i][j] << ")." << endl;
			}
		}
	}
	ofile.close();

}








