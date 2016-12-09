# SearchTextField
A UITextField subclass that allows you to search a datasource and shows results as a drop down.

#Installation
Download and import the source.

#Usage

Storyboard: Add a textfield to the ViewController's view in the storyboard and change it's class to SearchTextField.

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textField.searchDelegate = self
        textField.setDataSource(["Paris", "London", "Madrid", "Detroit", "Dublin", "Manchester", "San Francisco", "New York", "Melbourne", "Chicago", "Madison", "Denver", "Washington", "Milan"])
        
    }
    
Programmatic:

    override func viewDidLoad() {
        
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.

        let textField = SearchTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        textField.placeholder = "Enter City"
        textField.borderStyle = .roundedRect
        view.addSubview(textField)
        
        textField.searchDelegate = self
        textField.setDataSource(["Paris", "London", "Madrid", "Detroit", "Dublin", "Manchester", "San Francisco", "New York", "Melbourne", "Chicago", "Madison", "Denver", "Washington", "Milan"])
        
        let widthConstraint = NSLayoutConstraint(item: textField, attribute: .width, relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 250)
        textField.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30)
        textField.addConstraint(heightConstraint)
        
        let xConstraint = NSLayoutConstraint(item: textField, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60)

        view.addConstraint(xConstraint)
        view.addConstraint(yConstraint)
    }

#Results
![Screenshot](https://sayeedhussain.github.io/searchtextfield-screenshot1.png)
