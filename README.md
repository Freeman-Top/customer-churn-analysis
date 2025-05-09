# customer-churn-analysis
Capstone project analysing customer churn using SQL, Power BI, and machine learning.

# Customer Churn Analysis (Capstone Project)

## 🔍 Overview
This project analyzes telecom customer churn to uncover patterns and build predictive models. It includes SQL-based data exploration, storytelling with Power BI, and both supervised and unsupervised machine learning in Python.

## 📊 Tools Used
- Azure Data Studio
- Power BI Desktop
- Python (Visual Studio Code)

## 📁 Project Structure
- `Readme.md`: Project overview, tools used, steps, and key findings
- `Azure Data Studio`: SQL queries used for data exploration and screenshots
- `powerbi/`: Power BI dashboard file and screenshots
- `vs code/`: for data cleaning, clustering, and classification
- `reports/`: Final report and summary slides

## 🔬 Machine Learning
- **Unsupervised**: K-Means clustering (An unsupervised learning algorithm that groups customers into clusters based on behavioral patterns.)
- Metric used: Silhouette Score(Used to evaluate how well the data points fit within their assigned clusters — a higher score indicates better-defined clusters.)
- **Supervised**: Random Forest, Logistic Regression, Gradient Boosting to predict churn
- Metrics used: Accuracy, Precision, Recall, ROC AUC

## 📈 Power BI Dashboard

### 📌 Key Insights From Power BI Dashboard
1. Customer Demographics & Churn
- Senior Citizens have a different churn pattern than non-seniors.
- Gender has minimal impact on churn.
- Customers with dependents churn slightly less.
- Customers with partners show varied churn behavior.
  
2. Contract & Billing Impact
- Month-to-month contracts have the highest churn rate.
- Long-term contracts (1 or 2 years) significantly reduce churn.
- Paperless billing customers churn more than traditional billing users.
- Payment method matters: Electronic check users churn more than automatic payment users.
  
3. Service & Subscription Impact
- Fiber optic users churn more than DSL users.
- Customers without add-ons (online security, backup, tech support) churn more.
- Customers with streaming services (TV & movies) have different churn patterns.
- Phone service customers show different retention trends than those without.

4. Financial & Tenure-Based Insights
- Higher monthly charges correlate with higher churn.
- Low-tenure customers (new customers) churn more frequently.
- High-spending, long-term customers are more loyal.
- Critical churn points: At the end of contract periods, spikes in churn are seen.

5. Behavioral Insights
- Customers without tech support are more likely to leave.
- Multiple service bundles (phone + internet + streaming) may improve retention.
- Automatic payment methods (bank transfer, credit card) reduce churn.

## 📚 Conclusion
This customer churn analysis project provided end-to-end insights by combining exploratory SQL queries, Power BI visualizations, and machine learning techniques. Key churn drivers were identified across customer demographics, service subscriptions, contract types, and billing behaviors.
Through unsupervised learning (K-Means), customer segments were discovered, revealing groups at high risk of churn. Supervised models like logistic regression and random forest effectively predicted churn with good accuracy, enabling targeted retention strategies.
Overall, the analysis suggests that improving long-term contracts, bundling services, and encouraging automatic payment methods could significantly reduce customer churn. These findings can guide telecom providers toward data-driven decision-making and customer loyalty improvements.


