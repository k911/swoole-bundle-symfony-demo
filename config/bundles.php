<?php

declare(strict_types=1);
use K911\Swoole\Bridge\Symfony\Bundle\SwooleBundle;
use Sensio\Bundle\FrameworkExtraBundle\SensioFrameworkExtraBundle;
use Symfony\Bundle\FrameworkBundle\FrameworkBundle;
use Symfony\Bundle\MonologBundle\MonologBundle;
use Symfony\Bundle\TwigBundle\TwigBundle;
use Symplify\ConsoleColorDiff\ConsoleColorDiffBundle;
use Twig\Extra\TwigExtraBundle\TwigExtraBundle;

return [
    FrameworkBundle::class => ['all' => true],
    SwooleBundle::class => ['all' => true],
    SensioFrameworkExtraBundle::class => ['all' => true],
    MonologBundle::class => ['all' => true],
    TwigBundle::class => ['all' => true],
    TwigExtraBundle::class => ['all' => true],
    ConsoleColorDiffBundle::class => ['dev' => true, 'test' => true],
];
