# Employee-Onboarding D365 Setup


[[_TOC_]]


# Overview

The Dynamics 365 Employee Onboarding App is designed to guide employees through their first year in a new role. It provides them with the necessary information and training, tailored to their specific role, career stage, and whether they are new to the company. The app's content is organized into various topics, each with one or more learning path. These paths are designed to reinforce skills and build confidence through the delivery of training modules in a variety of formats, catering to different learning styles.

# D365 Setup
**Install Employee Onboarding App Package**

•	Open Microsoft appsource and search for “Dynamics 365 Employee Onboarding” and click on “GET IT NOW” as shown below. 

![image.png](/.attachments/importfromappsource.png)

•	Select the environment, check the box to agree to the Microsoft terms and privacy policy, and click on 'Install' to install the Employee Onboarding App in your environment as shown below. 
![image.png](/.attachments/importselectenviron.png)
•	This process will take a few minutes to complete the installation. You should see the app as installed after a successful installation.
![image.png](/.attachments/installedapp.png)

•	Turn on Power Automate if it is not already activated during the solution import process. Create connections if they haven't already been created.
Sign into [Power Apps](https://make.powerapps.com/?utm_source=padocs&utm_medium=linkinadoc&utm_campaign=referralsfromdoc) and select Solutions from the left navigation. 
Select Employee Onboarding solution -->Cloud Flows --> Select the flow --> Turn On
![turnonpowerautomate.png](/.attachments/turnonpowerautomate.png)
![FlowTurnOn.png](/.attachments/FlowTurnOn.png)

# Data Setup

This step is required for the app to function properly. Download the data from [GitHub] (https://aka.ms/EmployeeOnboardingApp) --> **D365 Sample data** folder. Please refer to the "Order of Import" section to ensure that the data is imported in the correct order.
Data Import Steps :

Refer - [Import data in model-driven apps - Power Apps | Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/user/import-data?context=%2Fdynamics365%2Fcontext%2Fsales-context)

•	System Configuration
Go to advanced find and fing the entity "System Configuration"

![image.png](/.attachments/image1.png)

•	Select "System Configuration" entity
![image.png](/.attachments/image2.png)

•	Click "Import from excel" button (you can use import from CSV option as well)
![image.png](/.attachments/image3.png)

•	Choose file and select Next
![image.png](/.attachments/image4.png)

•	Review mapping if needed and click "Finish Import"

•	Track progress of import 
![image.png](/.attachments/image5.png)

•	Go to "System Configuration" entity and verify all records are imported.

![image.png](/.attachments/image6.png)



**Order of Import:**


|**Entity**|  **Data**|
|--|--|
|System Configuration |Required|
|Persona |Required |
|RoleRankSummary  |Required  |
|Learner |Required |
|Program Parameter |Required|
|Asset Catalog |Required  |
|Topics |Required |
|Paths  |Required  |
|Asset per path |Required  |
|Path per program parameter |Required |
|Area  |Optional |
|Program  |Optional |

# Share Canvas App

**Step 1: [Create a Microsoft Entra ID Security Group](https://learn.microsoft.com/en-us/microsoft-365/admin/email/create-edit-or-delete-a-security-group?view=o365-worldwide)**

This group will comprise the list of learners who require access to the canvas app.


**Step 2 : Create a Dynamics 365 team.**
- Go to https://admin.powerplatform.microsoft.com/ 
- Select the environment
- Select Teams
![image.png](/.attachments/image7.png)

- Click new team
- Provide the security group created in step 1

![image.png](/.attachments/image8.png)

- Assign "OLP Learner" security role to this team.

**Step 3: Share the App**


- Go to https://make.preview.powerapps.com/ and open Employee Onboarding solution
- Go to Apps 
![image.png](/.attachments/image9.png)

- Select the 3 dots on the app and click Share

![image.png](/.attachments/image10.png)

- Add the security group created in step 1 and click Share.


![image.png](/.attachments/image11.png)
