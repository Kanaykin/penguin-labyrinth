//
// MainScene class
//
var Step1 = function(){};

// Create callback for button
Step1.prototype.onPressButton = function()
{	
    // Rotate the label when the button is pressed
    this.helloLabel.runAction(cc.RotateBy.create(1,360));
};
