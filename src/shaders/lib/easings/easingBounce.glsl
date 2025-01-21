float easeOutBounce(float t) 
{
    if (t < 1.0 / 2.75) {
        return 7.5625 * t * t;
    } else if (t < 2.0 / 2.75) {
        t -= 1.5 / 2.75;
        return 7.5625 * t * t + 0.75;
    } else if (t < 2.5 / 2.75) {
        t -= 2.25 / 2.75;
        return 7.5625 * t * t + 0.9375;
    } else {
        t -= 2.625 / 2.75;
        return 7.5625 * t * t + 0.984375;
    }
}

float easeInBounce(float t) 
{
    return 1.0 - easeOutBounce(1.0 - t);
}

float easeInOutBounce(float t) 
{
    return t < 0.5
        ? (1.0 - easeOutBounce(1.0 - 2.0 * t)) * 0.5
        : (1.0 + easeOutBounce(2.0 * t - 1.0)) * 0.5;
}