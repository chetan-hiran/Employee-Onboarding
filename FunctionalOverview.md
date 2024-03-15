[[_TOC_]]
# Overview

The Dynamics 365 Employee Onboarding App is designed to guide employees through their first year in a new role. It provides them with the necessary information and training, tailored to their specific role, career stage, and whether they are new to the company. The app's content is organized into various topics, each with one or more learning path. These paths are designed to reinforce skills and build confidence through the delivery of training modules in a variety of formats, catering to different learning styles.

# Architecture :

![image.png](/.attachments/image12.png)


![image.png](/.attachments/image13.png)

# Entity Information
|**Entity**|  **Details**|
|--|--|
|**System Configuration** |This entity functions as a configuration job employed by automation processes. For instance, all entry dates are contingent upon the cutoff date for the learners' position entry, targeting only those who joined on or after July 1st, 2023. All fields depicted in the following screenshot should be created in this entity.![image.png](/.attachments/image14.png) |
|**Persona** |This entity houses master persona data. Some examples include NTR IC (New to Role Individual Contributor), NTM IC (New to Microsoft Individual Contributor), Manager - New Hire, and Manager - M to M (Manager moved to a different position). All values depicted in the screenshot should be included in this entity.![image.png](/.attachments/image15.png) |
|**Role Rank Summary**  |The role rank summary contains learners' role summaries. Rank 1 is designated for individual contributor role summaries, while Rank 2 is assigned to manager role summaries. This information is essential for assigning personas to learners.![image.png](/.attachments/image16.png)|
|**Learner** |Learner are the contact records.|
|**Program Parameter** |The program parameter entity is utilized to target specific learners for asset assignment.![image.png](/.attachments/image17.png)|
|**Asset Catalog** |The asset catalog contains all the assets or training materials intended for assignment to the learners.|
|**Topics** |Topics serve as the headings for the group of paths displayed within the Canvas app.|
|**Paths**  |Path is logical grouping of assets|
|**Asset per path** |The "Asset per path" entity contains the master data of assets assigned to each specific path.|
|**Path per program parameter** |The "Path per program parameter" entity holds the master data of paths assigned to each program parameter.|
|**Learner Program parameter**| The learner program parameter entity compares learner and program parameters using qualifier 1, qualifier 2, organization, role summary, and persona to generate an association record.|
|**Asset per learner** |The asset per learner entity is associated with records of assets and learners, created according to the learner program parameters.|

The screenshot displayed in the Canvas app illustrates the utilization of configuration data from the aforementioned entities to allocate assets to learners.

![image.png](/.attachments/image18.png)

# Canvas App Walkthrough

- Open Canvas App
- The left navigation bar contains a collection of topics and paths.
- Each topic serves as a headline and may include one or more paths within it.
- In the middle screen, you'll find assets related to the selected path, along with options to search and filter them.
- The progress bar indicates the completion status of the topic.

![image.png](/.attachments/image19.png)


- Click to open any asset.
- Select the "Launch" button to access and complete the asset.
- Utilize the "Bookmark" button to mark the asset for future reference.
- Click the "Mark as Complete" button to finish the course; this action tracks the completion date and updates the status accordingly.
- Use the "Rate Content" option to provide feedback and rate the application.

![image.png](/.attachments/image20.png)





