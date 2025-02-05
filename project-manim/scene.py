from manim import *


class CreateCircle(Scene):
    def construct(self):
        circle = Circle()  # create a circle
        circle.set_fill(PINK, opacity=0.5)  # set the color and transparency
        self.play(Create(circle))  # show the circle on screen

class SquareToCircle(Scene):
    def construct(self):
        circle = Circle()  # create a circle
        circle.set_fill(PINK, opacity=0.5)  # set color and transparency

        square = Square()  # create a square
        square.rotate(PI / 4)  # rotate a certain amount

        self.play(Create(square))  # animate the creation of the square
        self.play(Transform(square, circle))  # interpolate the square into the circle
        self.play(FadeOut(square))  # fade out animation

class MovingCircle(Scene):
    def construct(self):
        circle = Circle()  # create a circle
        circle.set_fill(PINK, opacity=0.5)  # set color and transparency

        self.play(Create(circle))  # show the circle on screen
        self.play(circle.animate.shift(LEFT))  # move the circle to the left
        self.play(circle.animate.shift(RIGHT * 2))  # move the circle to the right

class GrowingCircle(Scene):
    def construct(self):
        circle = Circle()  # create a circle
        circle.set_fill(PINK, opacity=0.5)  # set color and transparency

        self.play(Create(circle))  # show the circle on screen
        self.play(circle.animate.scale(2))  # scale the circle by a factor of 2
        self.play(circle.animate.scale(0.5))  # scale the circle by a factor of 0.5
        circle.set_fill(GREEN, opacity=0.5)  # change the color of the circle
        self.play(circle.animate.set_fill(GREEN))  # animate the color change

class RotatingCircle(Scene):
    def construct(self):
        circle = Circle()  # create a circle
        circle.set_fill(PINK, opacity=0.5)  # set color and transparency

        self.play(Create(circle))  # show the circle on screen
        self.play(circle.animate.rotate(PI / 2))  # rotate the circle by 90 degrees
        self.play(circle.animate.rotate(PI / 2))  # rotate the circle by another 90 degrees


