# app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Template Structure:
├── Title (String, Form name, it will display on top of the form)  
├── SectionName  
│   ├── Name  
│   │   ├── Label (String, Section name, it will display on top of the section)  
│   │   ├── Alert (String, Section alert message, it will display on top of the section under the label)    
│   │   ├── Hint  (String, Section hint message, it will display a question icon on top of the section next the alert)  
│   │   ├── Label (String, Section name, it will display on top of the section)  
│   │   ├── SectionView (String, How to display the section, Choose from: 'FormView' and 'TableView')    
│   │   ├── Expandable (bool, Must have if SectionView choose 'TableView')     
│   │   ├── tableIndex (List, Must have if SectionView choose 'TableView', Set [] if auto index)   
│   ├── sectionItem  
│   │   ├── Label (String, Section item name)  
│   │   ├── Type (String, item Type, Choose from: 'Text', 'Number', 'Comment', 'Dropdown', 'CheckBox', 'Date')  
│   │   ├── Options (List, Must have if Type choose 'Dropdown')  
│   │   ├── DbTableName (String, nullable, database table name)  
│   │   ├── DbColumnName (String, nullable, database ColumnName name)  
│   │   ├── Unit (String, nullable, Unit - display next to input box)  
│   │   ├── Required (bool, nullable, Must have if required)  
│   ├── sectionItem  
...  
│   ├── sectionItem  
├── SectionName   
....  
├── SectionName  

## Error Code:
#### \#101: Check form template section type.  
```
eg: Code: #101 in GeneralInfo-Description  
In the template file, Find key: GeneralInfo, sub-key: Description, and check the type of the section.  
```
