<?php

namespace Bs\BootstrapifyBundle\Twig;

use Symfony\Component\DependencyInjection\ContainerAwareInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Twig_Extension;
use Twig_SimpleFunction;

/**
 * Extensions for the twig templating language
 */
class BootstrapifyExtension extends Twig_Extension implements ContainerAwareInterface
{
    private $container;

    private $locale_map;

    /**
     * @param array $locale_map A mapping of alternative names for locales
     */
    public function __construct(array $locale_map = [])
    {
        $this->locale_map = $locale_map;
    }

    /**
     * {@inheritdoc}
     */
    public function setContainer(ContainerInterface $container = null)
    {
        $this->container = $container;
    }

    /**
     * {@inheritdoc
     */
    public function getFunctions()
    {
        return [
            new Twig_SimpleFunction(
                'bootstrapify_datepicker_locale',
                [$this, 'insertDatepickerLocale'],
                ['is_safe' => ['html']]
            )
        ];
    }

    /**
     * Retrieve the current locale.
     * @return string
     */
    protected function getLocale()
    {
        $locale = $this->container->get('request')->getLocale();
        if (isset($this->locale_map[$locale])) {
            $locale = $this->locale_map[$locale];
        }
        return $locale;
    }

    /**
     * Create a script tag for loading the active locale for the datepicker.
     * @return string
     */
    public function insertDatepickerLocale()
    {
        $locale = $this->getLocale();
        $url = '/bundles/bsbootstrapify/js/locale/bootstrap-datepicker/bootstrap-datepicker.' . $locale . '.js';
        return '<script src="' . $url . '" type="text/javascript"></script>';
    }

    /**
     * {@inheritdoc}
     */
    public function getName()
    {
        return "bs_bootstrapify_extension";
    }
}
