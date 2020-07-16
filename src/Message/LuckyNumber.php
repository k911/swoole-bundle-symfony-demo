<?php

declare(strict_types=1);

namespace App\Message;

final class LuckyNumber
{
    private $luckyNumber;

    public function __construct(int $luckyNumber)
    {
        $this->luckyNumber = $luckyNumber;
    }

    public function __toString(): string
    {
        return (string) $this->luckyNumber();
    }

    private function luckyNumber(): int
    {
        return $this->luckyNumber;
    }
}
